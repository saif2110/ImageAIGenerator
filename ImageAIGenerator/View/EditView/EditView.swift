//
//  EditView.swift
//  ImageAIGenerator
//
//  Created by Home on 11/11/22.
//

import SwiftUI

struct EditView: View {
  @AppStorage("AIGTK") var token: Int = 0
  @StateObject var viewModel = ViewModel()
  @State var text = "Enter prompt to edit"
  @State var selectedImage: Image?
  @State var emptyImage: Image = Image("editPlaceholder")
  @State private var keyboardHeight: CGFloat = 0
  @State var showCamera: Bool = false
  @State var showGallery: Bool = false
  
  @State var errorText: String = ""
  
  @State var lines: [Line] = []
  
  @State var showSubscriptionView = false
  
  @FocusState var isFocused: Bool
  @State var ShowIAP:Bool = false
  
  @State var fetchedImage:Image?
  
  @State var TEMP:Image = Image("bg")
  
  var currentImage: some View {
    if let selectedImage {
      return selectedImage
        .resizable()
        .scaledToFill()
        .frame(height: 350)
    } else {
      return emptyImage
        .resizable()
        .scaledToFill()
        .frame(height: 350)
    }
  }
  
  var body: some View {
    
    VStack {
      
      
      HStack{
        Text("Draw Using Finger")
          .font(Font.system(size: 29, weight: .black, design: .default))
          .foregroundColor(.white)
        Spacer()
      }
      
      
      Rectangle().fill(.clear)
        .frame(width: 0, height: 10, alignment: .center)
      
      
      Image("Imagecontainer")
        .resizable()
        .overlay {
          ZStack {
            AsyncImage(url: viewModel.imageURL) { image in
              image
                .resizable()
                .scaledToFill()
                .cornerRadius(61)
                .padding()
                .onAppear{
                  fetchedImage = image
                  ImageManager().saveImage(image: image.asUIImage())
                  //PhotoManager.shared.savePhoto(image.asUIImage())
                }
              
            }
          placeholder: {
            VStack {
              
              if !viewModel.isLoading {
                ZStack {
                  currentImage
                    .padding()
                  SwiftBetaCanvas(lines: $lines, currentLineWidth: 30)
                  
                }
                
              }else{
                
                ProgressView().tint(.white)
                
                  .padding(.bottom, 12)
                Text("Your image is being generated, wait for 12 seconds!")
                  .foregroundColor(.white)
                  .multilineTextAlignment(.center)
              }
              
            }
          }
            
          }
          
        }
        .cornerRadius(63)
        .aspectRatio(1, contentMode: .fit)
        .frame(minWidth: 170)
        .frame(minHeight: 170)
        .ignoresSafeArea(.keyboard)
      
      
      
      
      HStack {
        
        Button {
          showGallery.toggle()
        } label: {
          Image("Photos")
            .resizable()
            .frame(height: 41, alignment: .center)
        }
        
        .fullScreenCover(isPresented: $showGallery) {
          GalleryView(selectedImage: $selectedImage)
        }
        
        Spacer(minLength: 8)
        
        Button {
          
          guard !text.isEmpty else {return}
          
          if let image = fetchedImage?.asUIImage() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
          }
          
        } label: {
          Image("editSave")
            .resizable()
            .frame(height: 41, alignment: .center)
        }
        
        
      }.padding(.vertical)
        .padding(.horizontal,8)
      
      
      HStack {
        
        
        HStack {
          TextField(text, text: $text)
            .focused($isFocused)
            .font(Font.system(size: 17, weight: .regular, design: .rounded))
            .multilineTextAlignment(.leading)
          //.scrollContentBackground(.hidden)
            .foregroundColor(.white)
          
            .frame(height: 61)
            .multilineTextAlignment(.center)
          
            .onTapGesture {
              if text == "Enter prompt to edit" {
                text = ""
                isFocused = true
              }
              
              
            }
          
          Button {
            
            guard self.token != 0 else {
              return ShowIAP = true
            }
            
            guard text != "", text != "Enter prompt to edit",text.count > 2 else {
              errorText = "Please enter a prompt to obtain the desired image. (Minimum words require is 3)"
              return
            }
            
            
            guard selectedImage != nil else {
              errorText = "Please choose photo to edit using Ai."
              return
            }
            
            
            isFocused = false
            errorText = ""
            
//            guard AppUserDefaults.isPRO || AppUserDefaults.AppUsed == 0 else {
//              ShowIAP = true
//              return
//            }
            
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
              
              let selectedImageRenderer = ImageRenderer(content: currentImage)
              let maskRenderer = ImageRenderer(content: currentImage.reverseMask {
                SwiftBetaCanvas(lines: $lines, currentLineWidth: 30)
              })
              
              TEMP = Image(uiImage: maskRenderer.uiImage!)
              // selectedImage = Image(uiImage: selectedImageRenderer.uiImage!)
              
              
              Task {
                guard let selecteduiImage = selectedImageRenderer.uiImage,
                      let selectedPNGData = selecteduiImage.pngData(),
                      let maskuiImage = maskRenderer.uiImage,
                      let maskPNG = maskuiImage.pngData() else {
                  return
                }
                
                AppUserDefaults.AppUsed += 1
                self.viewModel.generateEdit(withText: text,
                                            imageData: selectedPNGData,
                                            maskData: maskPNG)
              }
              
            }
            
            
            
          } label: {
            Image("Create")
              .resizable()
              .frame(width: 105)
              .frame(height: 35)
          }
          .disabled(viewModel.isLoading)
          
          
        }.padding(.horizontal,12)
        
        
        
      }
      .background(Color(hex: 0x222141, alpha: 1))
      .cornerRadius(15)
      
      
      Text(errorText).foregroundColor(.red)
        .font(Font.system(size: 15))
        .multilineTextAlignment(.center)
        .padding(.horizontal)
      
      
      HStack {
        
        Button {
          viewModel.imageURL = nil
          selectedImage = nil
          lines.removeAll()
        } label: {
          
          Image("reset")
            .resizable()
            .frame(width: 160, height: 41, alignment: .center)
        } .disabled(viewModel.isLoading)
        
      }
      
      
      //.ignoresSafeArea(.keyboard)
      
      
      
      .padding(.top,10)
      .toolbar(content: {
        ToolbarItem(placement: .navigationBarTrailing) {
          
          //                    if !AppUserDefaults.isPremiumUser {
          Button{
            withAnimation{
              showSubscriptionView = true
            }
          }label: {
            HStack(spacing:8){
              //                                Text("\(settingsViewModel.credit) \(settingsViewModel.credit > 1 ? "Credits" : "Credit")")
              
            }
            .padding(.vertical,5)
            .padding(.leading, 5)
            .padding(.trailing, 8)
            //                            .overlay(
            //                                RoundedRectangle(cornerRadius: 20)
            //                                    .stroke(Color.appTheme, lineWidth:2)
            //                            )
          }
          //                    }
          
        }
        
      })
      .toolbar {
        ToolbarItem(placement: .keyboard) {
          
          Button(action: {
            isFocused = false
          }, label: {
            Image(systemName: "keyboard.chevron.compact.down")
          }).frame(maxWidth: .infinity, alignment: .trailing)
        }
      }
      .sheet(isPresented: $showSubscriptionView, content: {
        PaywallView()
      })
      
      
      
      //           // TEMP
      //                .resizable()
      //                .frame(width: 100, height: 100, alignment: .center)
      
      Spacer()
      
    }
    .padding(.horizontal)
    .padding(.top,4)
    .background {
      Image("bg")
        .resizable()
        .scaledToFill()
        .edgesIgnoringSafeArea(.all)
    }
    
    .overlay {
      if ShowIAP {
        InAppPurchases(close: $ShowIAP)
      }
    }
    
    
    //            .overlay {
    //
    //                VStack{
    //                    Spacer()
    //                    HStack(spacing: 60){
    //                        Button {
    //
    //                        } label: {
    //                            Image("coloredEdit")
    //                                .resizable()
    //                                .frame(width: 26, height: 26, alignment: .center)
    //                        }
    //
    //                        Button {
    //
    //                        } label: {
    //                            Image("main_White")
    //                                .resizable()
    //                                .frame(width: 26, height: 26, alignment: .center)
    //                        }
    //
    //
    //                        Button {
    //
    //                        } label: {
    //                            Image("setting")
    //                                .resizable()
    //                                .frame(width: 26, height: 26, alignment: .center)
    //                        }
    //
    //                    }
    //                    .frame(height: 60)
    //                    .frame(width: UIScreen.main.bounds.size.width-45)
    //                    .background(Color(hex: 0x222141, alpha: 1))
    //                    .cornerRadius(15)
    //
    //
    //
    //
    //                }
    //                .ignoresSafeArea(.keyboard)
    //
    //            }
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView()
  }
}


