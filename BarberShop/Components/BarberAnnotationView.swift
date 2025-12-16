//
//  BarberAnnotationView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 10/12/25.
//
/*
import Foundation
import SwiftUI
import _MapKit_SwiftUI
struct BarberAnnotationView: View {
    let barber: Barber
    @Binding var cameraPosition: MapCameraPosition
    @Binding var selectedBarber: Barber?

    var body: some View {
        Image(systemName: "scissors.circle.fill")
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.white)
            // Asegúrate de que Color(hex: ...) esté definido y accesible.
            .background(Color(hex: "#EE8F40"))
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.white, lineWidth: 2)
            )
            .onTapGesture {
                // Mover cámara hacia el barbero
                withAnimation(.easeInOut(duration: 0.5)) {
                    cameraPosition = .region(
                        MKCoordinateRegion(
                            center: barber.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                }
                // Mostrar tarjeta
                selectedBarber = barber
            }
    }
}
*/
