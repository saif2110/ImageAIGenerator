//
//  ContentView.swift
//  ImageAIGenerator
//
//  Created by Home on 10/11/22.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var settingsViewModel: SettingsViewModel
  let colors: [Color] = [ .yellow, .blue, .green, .indigo, .brown]
  let tabbarItems = [ "Random", "Travel", "Wallpaper", "Food", "Interior Design" ]
  @State var selectedView = "Home"
  @State var images:[Image] = [Image("Edit"),Image("main"),Image("photo_white")]
  @AppStorage("AIGTK") var token: Int = 0
  @AppStorage("isIAPOpened") var isIAPOpened: Bool = false
  
  let home = homeView()
  let edit = EditView()
  let photo = PhotoView()
  
  var currentView: any View {
    if selectedView == "Home" {
      return home
    } else if selectedView == "Edit" {
      return edit
    }else{
      return photo
    }
  }
  
  var body: some View {
    ZStack{
      AnyView(currentView)
      Spacer()
    }
    .overlay {
      
      if !isIAPOpened {
        
        VStack{
          HStack {
            Spacer()
            HStack(content: {
              Image("token")
                .resizable()
                .frame(width: 15, height: 15, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
              Text(String(token))
                .font(Font.system(size: 15, weight: .semibold, design: .monospaced))
            }) .padding(2)
              .padding(.horizontal,5)
              .cornerRadius(10)
              .overlay(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(.purple, lineWidth: 1)
              )
            
          }
          .padding()
          .padding(.top,-10)
          
          
          Spacer()
          HStack(spacing: 60){
            Button {
              selectedView = "Edit"
              images = [Image("coloredEdit"),Image("main_White"),Image("photo_white")]
            } label: {
              images[0]
                .resizable()
                .frame(width: 26, height: 26, alignment: .center)
            }
            
            Button {
              selectedView = "Home"
              images = [Image("Edit"),Image("main"),Image("photo_white")]
            } label: {
              images[1]
                .resizable()
                .frame(width: 26, height: 26, alignment: .center)
            }
            
            
            Button {
              selectedView = "Photo"
              images = [Image("Edit"),Image("main_White"),Image("photo")]
            } label: {
              images[2]
                .resizable()
                .frame(width: 26, height: 26, alignment: .center)
            }
            
          }
          .frame(height: 60)
          .frame(width: UIScreen.main.bounds.size.width-45)
          .background(Color(hex: 0x222141, alpha: 1))
          .cornerRadius(15)
          
          
        }
        .ignoresSafeArea(.keyboard)
      }
    }
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView() .environmentObject(SettingsViewModel())
  }
}
