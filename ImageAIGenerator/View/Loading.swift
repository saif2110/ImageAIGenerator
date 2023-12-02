//
//  Loading.swift
//  ImageAIGenerator
//
//  Created by Admin on 25/11/23.
//

import SwiftUI

struct Loading: View {
    var body: some View {
        ZStack {
            Image("bg")
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                .foregroundColor(Color.black.opacity(0.9))
                .blur(radius: 20)
                .edgesIgnoringSafeArea(.all)
               
        }
           
//        .blur(radius: 10)
        
        .overlay {
            VStack(spacing: -100) {
                Spacer()
                LottieView(name: "load", loopMode: .loop)
                    .frame(width: 400, height: 400, alignment: .center)
                Text("We are generating your image based on the provided prompt. The process may take up to 10-20 seconds, depending on the complexity of your prompt.")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                Spacer()
                
            }
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
