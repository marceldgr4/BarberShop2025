//
//  HomeSeachBarView.swift
//  BarberShop
//
//  Created by Marcel DiazGranados Robayo on 5/01/26.
//

import SwiftUI

struct HomeSearchBarView: View {
    @Binding var text: String
    var body: some View {
        HStack(spacing:12){
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Seach services, Barbers...", text:$text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            if !text.isEmpty{
                Button(action:{
                    text = ""
                }){
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

#Preview {
    HomeSearchBarView(text:.constant(""))
}
