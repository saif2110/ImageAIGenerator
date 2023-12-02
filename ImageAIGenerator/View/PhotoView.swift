//
//  PhotoView.swift
//  ImageAIGenerator
//
//  Created by Admin on 27/11/23.
//

import SwiftUI

struct PhotoView: View {
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @State private var isPresented = false
    @State var image: Image? = nil
    
    
    
    @State var photos = PhotoManager.shared.retrievePhotos()
    
    var body: some View {
        VStack{
            HStack{
                Text("Generated Photos")
                    .font(Font.system(size: 28, weight: .black, design: .default))
                    .foregroundColor(.white)
                Spacer()
            }
            
            
            if photos?.count == 0 || photos?.count == nil {
                
                VStack {
                    Spacer()
                    Image(systemName: "photo").resizable()
                        .frame(width: 30, height: 30, alignment: .center)
                        .padding(.bottom,7)
                    Text("Generated Images will display here.")
                }
                
            }
            
            ScrollView {
                LazyVGrid(columns: columns,spacing: 5) {
                    ForEach(photos ?? [], id: \.self) { item in
                        
                        Button {
                            
                            image =  Image(uiImage: item)
                            isPresented.toggle()
                            
                        } label: {
                            Image(uiImage: item)
                                .resizable()
                                .aspectRatio(1,contentMode: .fill)
                                .cornerRadius(21)
                                .onAppear{
                                    print(item)
                                }
                        }
                        
                    }
                    Rectangle().fill(.clear).frame(height: 50)
                }
            }.background(.clear)
                .padding(.top,15)
            
            Spacer()
        }
        .padding(.top,4)
        .padding(.horizontal)
        .background {
            Image("bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
        }
        
        .overlay {
            VStack{
                if isPresented {
                    PhotoBlack(isPresented: $isPresented, photo: image!)
                }
            }
        }
        
        //        .fullScreenCover(isPresented: $isPresented) {
        //
        //                if let unwrappedImage = image {
        //                  //  DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.5) {
        //                        PhotoBlack(photo: unwrappedImage)
        //                    //}
        //                } else {
        //                    // Handle the case where image is nil, perhaps by showing a placeholder or default image
        //                    PhotoBlack(photo: Image("Photo"))
        //                }
        //
        //        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView()
    }
}
