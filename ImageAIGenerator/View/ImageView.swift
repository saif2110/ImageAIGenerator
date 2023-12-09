//
//  ImageView.swift
//  ImageAIGenerator
//
//  Created by Admin on 26/11/23.
//

import SwiftUI
import UIKit


struct ImageView: View {
  
  @Binding var initDismiss:Bool
  @Environment(\.requestReview) var requestReview
  @StateObject var viewModel = ViewModel()
  @Environment(\.dismiss) var dismiss
  @State var text:String = ""
  @State var itemLocal:String = ""
  @State var selectedResolution = ""
  @State private var imageLocal: Image?
  var body: some View {
    NavigationView {
      ZStack {
        // Background Image
        Image("bg") // Replace with your actual background image name
          .resizable()
          .scaledToFill()
          .edgesIgnoringSafeArea(.all)
          .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        VStack {
          HStack {
            Button {
              viewModel.isEditedClick = false
              self.initDismiss = true
              self.dismiss()
            } label: {
              Image(systemName: "xmark")
                .foregroundColor(.white)
            }
            Spacer()
          }
          .padding(.leading,30)
          .padding(.top,50)
          ScrollView(.vertical, showsIndicators: false, content: {
            
            ScrollViewReader{reader in
              
              VStack {
                
                Image("Imagecontainer")
                  .resizable()
                  .frame(width:  UIScreen.main.bounds.width-25)
                  .aspectRatio(1, contentMode: .fit)
                  .cornerRadius(63)
                  .overlay {
                    
                    AsyncImage(url: viewModel.imageURL) { image in
                      
                      image
                        .resizable()
                        .scaledToFit()
                        .onAppear{
                          imageLocal = image
                          ImageManager().saveImage(image: image.asUIImage())
                          requestReview()
                          //PhotoManager.shared.savePhoto(image.asUIImage())
                        }
                      
                    } placeholder: {
                      VStack {
                        ProgressView().tint(.white)
                        
                          .padding(.bottom, 12)
                        Text("Your image is being generated, wait for 12 seconds!")
                          .foregroundColor(.white)
                          .multilineTextAlignment(.center)
                        
                      }
                      .frame(width: 300, height: 300)
                    }.cornerRadius(63)
                    
                    
                    
                      .padding(8)
                  }
                  .padding(.top,10)
                
                HStack{
                  
                  Button {
                    guard !text.isEmpty else {return}
                    
                    if let image = imageLocal?.asUIImage() {
                      UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                    
                    
                    
                    
                  } label: {
                    Image("save")
                      .resizable()
                      .frame(height: 45)
                  }
                  
                  Button {
                    guard !text.isEmpty else {return}
                    
                    
                    if let image = imageLocal?.asUIImage() {
                      showShareSheet(with: [image])
                    }
                    
                    
                    
                  } label: {
                    Image("share")
                      .resizable()
                      .frame(height: 44)
                  }
                  
                }.padding(.top,25)
                
                Button {
                  guard !text.isEmpty else {return}
                  viewModel.isEditedClick = true
                  self.initDismiss = true
                  self.dismiss()
                  
                } label: {
                  Image("editButton")
                    .resizable()
                    .frame(height: 44)
                }.padding(.top,4)
                
              }
              .padding()
            }
          })
          
        }
      }
    }
    .onAppear{
      guard !text.isEmpty else {return}
      
      AppUserDefaults.AppUsed += 1
      
      Task {
        await viewModel.generateImage(withText: text + ", \(itemLocal)", withText: selectedResolution)
      }
    }
    .overlay {
      if viewModel.isLoading {
        Loading()
      }
    }
  }
  
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(initDismiss:.constant(false))
  }
}

extension View {
  // This function changes our View to UIView, then calls another function
  // to convert the newly-made UIView to a UIImage.
  public func asUIImage() -> UIImage {
    let controller = UIHostingController(rootView: self)
    
    // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
    controller.view.backgroundColor = .clear
    
    controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
    UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
    
    let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
    controller.view.bounds = CGRect(origin: .zero, size: size)
    controller.view.sizeToFit()
    
    // here is the call to the function that converts UIView to UIImage: `.asUIImage()`
    let image = controller.view.asUIImage()
    controller.view.removeFromSuperview()
    return image
  }
}

extension UIView {
  // This is the function to convert UIView to UIImage
  public func asUIImage() -> UIImage {
    let renderer = UIGraphicsImageRenderer(bounds: bounds)
    return renderer.image { rendererContext in
      layer.render(in: rendererContext.cgContext)
    }
  }
}


extension View {
  /// Show the classic Apple share sheet on iPhone and iPad.
  ///
  func showShareSheet(with activityItems: [Any]) {
    guard let source = UIApplication.shared.windows.last?.rootViewController else {
      return
    }
    
    let activityVC = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: nil)
    
    if let popoverController = activityVC.popoverPresentationController {
      popoverController.sourceView = source.view
      popoverController.sourceRect = CGRect(x: source.view.bounds.midX,
                                            y: source.view.bounds.midY,
                                            width: .zero, height: .zero)
      popoverController.permittedArrowDirections = []
    }
    source.present(activityVC, animated: true)
  }
}

