//
//  Loaders.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 27/12/25.
//

import Foundation


extension BookingViewModel{
   
     func load (_ operation: @escaping() async throws -> Void) async{
        isLoading = true
        errorMessage = nil
        do{
            try await operation()
        } catch{
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
   
    func loadBranches() async{
        await load{
            self.branches = try await self.branchService.fetchBranches()
        }
     
    }
     
    func loadBarbers() async{
        guard let branchId = selectedBranch?.id else {return}
        await load{
            self.barbers = try await self.barberService.fetchBarbers(branchId: branchId)
        }
    }
    
    func loadService() async{
        await load{
            self.services = try await self.serviceService.fetchServices()
        }
        
    }
    func loadAvailableTimeSlots() async{
        availableTimeSlots = generateTimeSlot()
    }
    
    private func generateTimeSlot() -> [String]{
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        var slots: [String] = [ ]
        var time = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
        
        while calendar.component(.hour, from: time) < 18 {
            slots.append(formatter.string(from: time))
            time = calendar.date(byAdding: .minute, value: 30, to: time)!
        }
        return slots
    }
}
