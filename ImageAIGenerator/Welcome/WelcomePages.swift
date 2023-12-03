//
//  WelcomePages.swift
//  ImageAIGenerator
//
//  Created by Admin on 29/11/23.
//

import SwiftUI

var desc = "One-Click AI Avatar Generator: Create your own AI avatar, AI portrait photos effortlessly without any artistic skills or complex software. Instantly generate digital characters with just a click!"

var desc2 = "Craft your personalized AI avatars and portrait photos seamlessly, no need for artistic expertise or complicated software. Generate digital characters with a single click for an effortless and quick experience!"

var desc3 = "Effortlessly craft your unique AI avatars and portrait photos without any artistic skills or complex software. Instantly generate digital characters with just a click, and enhance them further with powerful AI editing capabilities!"

struct WelcomePages: View {
    @State var ImageArray = ["SS1","SS2","SS3"]
    @State var title = ["Ai Image Generetor","Create Ai Images","Edit Images with Ai"]
    @State var descriptions = [desc,desc2,desc3]
    @State var selected = 0
    @State var showInapp = false
    @State var close = false
    @AppStorage("isWelcomePageShown") var isWelcomePageShown: Bool = false
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    Image(ImageArray[selected])
                        .resizable()
                        .aspectRatio(0.7, contentMode: .fill)
                        .padding(.horizontal,35)
                        .padding(.bottom,25)
                    
                    Text(title[selected])
                        .font(Font.system(size: 33, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    
                    Text(descriptions[selected])
                        .font(Font.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.6)
                        .lineLimit(5)
                        .multilineTextAlignment(.center)
                        .padding(.vertical,-2)
                    
                    
                    Button {
                        
                        if selected == 2 {
                            showInapp = true
                           return
                        }
                        
                        guard selected < ImageArray.count-1 else {return}
                        
                        selected += 1
                        
                    } label: {
                        Image("buttonBG")
                            .resizable()
                            .overlay {
                                Text("Continue")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold, design: .default))
                            }
                    }.frame(height: 55, alignment: .center)
                        .padding(.top,45)
                        .padding(.horizontal,20)
                      
                        

                    
                    Spacer()
                }
            }
        }
        
        .overlay {
                ZStack {
                    if showInapp {
                        InAppPurchases(close:$close)
                    }
                }
        }
        
        
        .background {
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
        
        .onChange(of: close) { newValue in
            if close {
                isWelcomePageShown = true
            }
        }
       
    }
}

struct WelcomePages_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePages()
    }
}
