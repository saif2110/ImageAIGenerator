//
//  InAppPurchases.swift
//  ImageAIGenerator
//
//  Created by Admin on 02/12/23.
//

import SwiftUI
import RevenueCat
import StoreKit


let inAppPurchases = "AiArtCoins"

struct InAppPurchases: View {
   @AppStorage("isIAPOpened") var isIAPOpened: Bool = false
    @Environment(\.requestReview) var requestReview
  @AppStorage("AIGTK") var token: Int = 0
    @Binding var close:Bool
    @State var price = ""
    @State var package:Package?
    @State var isLoading = false
    @State var showingAlert = false
    @State var AlertMessage = "Error"
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    Image("SS4")
                        .resizable()
                        .aspectRatio(0.7, contentMode: .fill)
                        .padding(.horizontal,35)
                        .padding(.bottom,25)
                    
                    Text("Buy Ai Credits!")
                        .font(Font.system(size: 30, weight: .bold, design: .rounded))
                        .minimumScaleFactor(0.6)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .lineLimit(1)
                    
                    
                    Text("Unlock all the feature, remove ads, generate/edit fifty photos with fifty credits, all for just \(price).\nYou can generate as well as edit photos with these credits. These credits have no expiration at all.")
                        .font(Font.system(size: 15, weight: .regular, design: .default))
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.6)
                        .lineLimit(5)
                        .multilineTextAlignment(.center)
                        .padding(.vertical,-2)
                    
                    
                    Button {
                        
                        guard package != nil, !isLoading else {return}
                        
                        isLoading = true
                        
                        Purchases.shared.purchase(package: package!) { (transaction, customerInfo, error, userCancelled) in
                            
                            isLoading = false
                            
                            if customerInfo?.entitlements[inAppPurchases]?.isActive == true {
                                
                                 token += 50
                               // AppUserDefaults.isPRO = true
                                isIAPOpened = false
                                close.toggle()
                                
                            }
                        }
                        
                    } label: {
                        Image("buttonBG")
                            .resizable()
                            .overlay {
                                Text("Get Credits Now")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold, design: .default))
                            }
                    }.frame(height: 50, alignment: .center)
                        .padding(.top,45)
                        .padding(.horizontal,20)
                    
                    
//                    HStack {
//                        
//                        
//                        Button {
//                            guard let url = URL(string: "https://apps15.com/privacy.html") else { return }
//                            UIApplication.shared.open(url)
//                        } label: {
//                            Text("Privacy policy")
//                                .font(.system(size: 11))
//                                .foregroundColor(.white.opacity(0.7))
//                        }
//                        
//                        
//                        Spacer()
//                        
//                        Button {
//                            
//                            Purchases.shared.restorePurchases { purchaserInfo, error in
//                                if !(purchaserInfo?.entitlements.active.isEmpty ?? false) {
//                                    
//                                    AppUserDefaults.isPRO = true
//                                    
//                                }else{
//                                    AlertMessage = "Error! Unable to purchase anything. No Purchase found."
//                                    showingAlert = true
//                                }
//                            }
//                            
//                        } label: {
//                            Text("Retore Purchase")
//                                .font(.system(size: 11))
//                                .foregroundColor(.white.opacity(0.7))
//                        }
//                        
//                        Spacer()
//                        
//                        Button {
//                            guard let url = URL(string: "https://apps15.com/termsofuse.html") else { return }
//                            UIApplication.shared.open(url)
//                        }label:{
//                            Text("Terms of Service")
//                                .font(.system(size: 11))
//                                .foregroundColor(.white.opacity(0.7))
//                        }
//                        
//                        
//                    }
//                    .padding()
                    
                    Rectangle().fill(.clear).frame(height: 50)
                    
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
        .overlay{
            VStack {
                HStack {
                    Spacer()
                    Button {
                      isIAPOpened = false
                        close.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .foregroundColor(.white.opacity(0.4))
                            .frame(width: 12, height: 12, alignment: .center)
                    }
                }.padding(.trailing)
                
                Spacer()
                
                if isLoading {
                    ProgressView("Loading")
                        .progressViewStyle(.circular)
                        .tint(.purple)
                        .foregroundColor(.purple)
                    
                    
                }
                Spacer()
            }
            
            
        }
        
        .alert(AlertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
        
        .onAppear{
            requestReview()
            Purchases.shared.getOfferings { (offerings, error) in
                if let packages = offerings?.offering(identifier: inAppPurchases)?.availablePackages {
                    
                    self.package = packages.first
                    
                }
            }
            
            Purchases.shared.getOfferings { (offerings, error) in
                if let offerings {
                    price = offerings.current?.availablePackages.first?.localizedPriceString ?? "$0.00"
                }
            }
        }
    }
}


struct InAppPurchases_Previews: PreviewProvider {
    static var previews: some View {
        InAppPurchases(close: .constant(false))
    }
}

struct ActivityIndicator: UIViewRepresentable {
    
    typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool
    fileprivate var configuration = { (indicator: UIView) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
