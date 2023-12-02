//
//  PremiumHeader.swift
//  ImageAIGenerator
//
//  Created by Admin on 30.07.2023.
//

import SwiftUI

struct PremiumHeader: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    var body: some View {
        HStack{
            
            Image(systemName: "c.circle.fill")
                .font(.title)
                .foregroundColor(.yellow)
            
            Text("\(settingsViewModel.credit > 1 ? "Credits" : "Credit")")
                .font(.headline)
            Spacer()
            Text("\(settingsViewModel.credit)")
                .font(.headline)
                .fontWeight(.bold)
            
        }
        .foregroundColor(.white)
        .padding()
      //  .background(Color.appTheme)
//        .background(LinearGradient(colors: [Color.purple, Color.orange], startPoint: .leading, endPoint: .trailing))
    }
}

struct PremiumHeader_Previews: PreviewProvider {
    static var previews: some View {
        PremiumHeader()
    }
}

