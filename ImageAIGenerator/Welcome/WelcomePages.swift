//
//  WelcomePages.swift
//  ImageAIGenerator
//
//  Created by Admin on 29/11/23.
//

import SwiftUI

struct WelcomePages: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Image("SS1")
                        .resizable()
                        .aspectRatio(0.77, contentMode: .fill)
                        .padding(.horizontal,25)
                        .padding(.bottom,25)
                    
                    Text("AI Image Generetor App")
                        .font(Font.system(size: 33, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    
                    Text("One-Click AI Avatar Generator: Create your own AI avatar, AI portrait photos effortlessly without any artistic skills or complex software. Instantly generate digital characters with just a click!")
                        .font(Font.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.6)
                        .lineLimit(5)
                        .multilineTextAlignment(.center)
                        .padding(.vertical,-2)
                    
                    Spacer()
                }
            }
        }
        .background {
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct WelcomePages_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePages()
    }
}
