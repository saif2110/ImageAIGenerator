//
//  PhotoBlack.swift
//  ImageAIGenerator
//
//  Created by Admin on 28/11/23.
//

import SwiftUI

struct PhotoBlack: View {
    @Binding var isPresented:Bool
    // @Environment(\.presentationMode) var presentationMode
    var photo:Image = Image("photo")
    var body: some View {
        VStack{
            HStack {
                Button {
                    isPresented = false
                    // presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(.white)
                    
                }
                Spacer()
            }.padding()
            Spacer()
            photo
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(12)
            
            HStack{
                
                Button {
                    
                    UIImageWriteToSavedPhotosAlbum(photo.asUIImage(), nil, nil, nil)
                    
                } label: {
                    Image("save")
                        .resizable()
                        .frame(height: 45)
                }
                
                Button {
                    
                    showShareSheet(with: [photo.asUIImage()])

                } label: {
                    Image("share")
                        .resizable()
                        .frame(height: 44)
                }
                
            }
                .padding()
            
            Spacer()
        }.background(.black)
    }
}

struct PhotoBlack_Previews: PreviewProvider {
    static var previews: some View {
        PhotoBlack(isPresented: .constant(true))
    }
}
