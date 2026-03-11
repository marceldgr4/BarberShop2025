import Foundation
import Supabase

final class AppointmentService {

    internal let client: SupabaseClient
    private let decoder = JSONDecoder()

    init(client: SupabaseClient = SupabaseManagerSecure.shared.client) {
        self.client = client
    }

    convenience init() {
        self.init(client: SupabaseManagerSecure.shared.client)
    }

    /// Crea una nueva cita
    func createAppointment(
        //userId: UUID,
        barberId: UUID,
        serviceId: UUID,
        date: String,
        time: String,
        durationMinutes: Int,
        price: Double,
        notes: String? = nil
    ) async throws -> Appointment {

        let userId = try await client.auth.session.user.id

        let statusResponse =
            try await client
            .from("appointment_statuses")
            .select()
            .eq("name", value: "pending")
            .single()
            .execute()

        let statusData =
            try JSONSerialization.jsonObject(with: statusResponse.data) as? [String: Any]

        guard let statusIdString = statusData?["id"] as? String,
            let statusId = UUID(uuidString: statusIdString)
        else {
            throw NSError(
                domain: "Appointment", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Status not found"])
        }

        let formattedTime =
            time.contains(":")
            ? (time.count == 5 ? "\(time):00" : time)
            : "\(time):00:00"

        let newAppointment = NewAppointment(
            userId: userId,
            barberId: barberId,
            serviceId: serviceId,
            statusId: statusId,
            appointmentDate: date,
            appointmentTime: formattedTime,
            durationMinutes: durationMinutes,
            totalPrice: price,
            notes: notes
        )

        let response =
            try await client
            .from("appointments")
            .insert(newAppointment)
            .select()
            .single()
            .execute()

        return try decoder.decode(Appointment.self, from: response.data)
    }

    /// Obtiene las citas del usuario actual
    func fetchUserAppointments() async throws -> [AppointmentDetail] {

        let userId = try await client.auth.session.user.id

        let response =
            try await client
            .from("appointments")
            .select(
                """
                    id,
                    appointment_date,
                    appointment_time,
                    duration_minutes,
                    total_price,
                    notes,
                    appointment_statuses!inner(name),
                    barbers!inner(full_name, photo_url, branches!inner(name, address)),
                    services!inner(name)
                """
            )
            .eq("user_id", value: userId.uuidString)
            .order("appointment_date", ascending: false)
            .execute()

        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []

        let appointments = json.compactMap { dict -> AppointmentDetail? in

            guard
                let id = dict["id"] as? String,
                let date = dict["appointment_date"] as? String,
                let time = dict["appointment_time"] as? String,
                let price = dict["total_price"] as? Double,
                let status = dict["appointment_statuses"] as? [String: Any],
                let statusName = status["name"] as? String,
                let barber = dict["barbers"] as? [String: Any],
                let barberName = barber["full_name"] as? String,
                let service = dict["services"] as? [String: Any],
                let serviceName = service["name"] as? String,
                let branch = barber["branches"] as? [String: Any],
                let branchName = branch["name"] as? String,
                let branchAddress = branch["address"] as? String
            else {
                return nil
            }

            return AppointmentDetail(
                id: UUID(uuidString: id) ?? UUID(),
                appointmentDate: date,
                appointmentTime: time,
                durationMinutes: dict["duration_minutes"] as? Int ?? 0,
                totalPrice: price,
                notes: dict["notes"] as? String,
                statusName: statusName,
                barberName: barberName,
                barberPhoto: barber["photo_url"] as? String ?? "",
                serviceName: serviceName,
                branchName: branchName,
                branchAddress: branchAddress
            )
        }

        return appointments
    }

    /// Cancelar cita
    func cancelAppointment(appointmentId: UUID) async throws {

        let cancelledStatusId = try await getCancelledStatusId()

        try await client
            .from("appointments")
            .update([
                "status_id": cancelledStatusId.uuidString,
                "updated_at": Date().ISO8601Format(),
            ])
            .eq("id", value: appointmentId.uuidString)
            .execute()
    }

    private func getCancelledStatusId() async throws -> UUID {

        let response =
            try await client
            .from("appointment_statuses")
            .select()
            .eq("name", value: "cancelled")
            .single()
            .execute()

        let json = try JSONSerialization.jsonObject(with: response.data) as? [String: Any]

        guard let statusId = json?["id"] as? String,
            let validStatusId = UUID(uuidString: statusId)
        else {
            throw NSError(
                domain: "Appointment", code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Status not found"])
        }

        return validStatusId
    }

    /// Obtener citas por estado
    func fetchAppointmentByStatus(status: String) async throws -> [AppointmentDetail] {

        let userId = try await client.auth.session.user.id

        let response =
            try await client
            .from("appointments")
            .select(
                """
                    id,
                    appointment_date,
                    appointment_time,
                    duration_minutes,
                    total_price,
                    notes,
                    appointment_statuses!inner(name),
                    barbers!inner(full_name, photo_url, branches!inner(name, address)),
                    services!inner(name)
                """
            )
            .eq("user_id", value: userId.uuidString)
            .eq("appointment_status.name", value: status)
            .order("appointment_date", ascending: false)
            .execute()

        let json = try JSONSerialization.jsonObject(with: response.data) as? [[String: Any]] ?? []

        let appointments = json.compactMap { dict -> AppointmentDetail? in

            guard
                let id = dict["id"] as? String,
                let date = dict["appointment_date"] as? String,
                let time = dict["appointment_time"] as? String,
                let price = dict["total_price"] as? Double,
                let status = dict["appointment_statuses"] as? [String: Any],
                let statusName = status["name"] as? String,
                let barber = dict["barbers"] as? [String: Any],
                let barberName = barber["full_name"] as? String,
                let service = dict["services"] as? [String: Any],
                let serviceName = service["name"] as? String,
                let branch = barber["branches"] as? [String: Any],
                let branchName = branch["name"] as? String,
                let branchAddress = branch["address"] as? String
            else {
                return nil
            }

            return AppointmentDetail(
                id: UUID(uuidString: id) ?? UUID(),
                appointmentDate: date,
                appointmentTime: time,
                durationMinutes: dict["duration_minutes"] as? Int ?? 0,
                totalPrice: price,
                notes: dict["notes"] as? String,
                statusName: statusName,
                barberName: barberName,
                barberPhoto: barber["photo_url"] as? String ?? "",
                serviceName: serviceName,
                branchName: branchName,
                branchAddress: branchAddress
            )
        }

        return appointments
    }
}
