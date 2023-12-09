//
//  GenerateView.swift
//  ImageAIGenerator
//
//  Created by Home on 10/11/22.
//

import SwiftUI
import Combine

enum CreditKey: String {
    case credit = "consumable.credit"
}



struct GenerateView: View {
  @AppStorage("isIAPOpened") var isIAPOpened: Bool = false
    @State var initDismiss:Bool = false
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = ViewModel()
    @State var text = "Enter Prompt"//"Astronaut riding a horse in space"//""//"Two astronauts exploring the dark, cavernous interior of a huge derelict spacecraft"
    @State var showSubscriptionView = false
    @State private var selectedStyle: Style = .digitalArt
    @State private var selectedResolution: Resolution = ._256
    @State private var showingAlert = false
    @FocusState var isFocused: Bool
    @State private var keyboardHeight: CGFloat = 0
    @State var itemLocal:String = ""
    @State var promtToadd:String = ""
    @State var isPresented:Bool = false
    @State var ShowIAP:Bool = false
    @AppStorage("AIGTK") var token: Int = 0
    //    @State var credit = AppUserDefaults.credit
    
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
                            dismiss()
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
                            
                            Image("Imagecontainer")
                                .resizable()
                                .frame(width:  UIScreen.main.bounds.width-25)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(63)
                                .overlay {
                                    Image(itemLocal)
                                        .resizable()
                                        .padding(10)
                                }
                            
                            
                            
                            HStack {
                                
                                
                                HStack {
                                    
                                    Text("Choose Quality")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 17, weight: .regular, design: .default))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Picker("Style:", selection: $selectedStyle) {
                                        ForEach(Style.allValues, id: \.self) { item in
                                            Text(item.rawValue)
                                                .tag(item)
                                            
                                            
                                        }
                                    }.tint(.white)
                                    
                                }.padding(.horizontal,12)
                                
                                
                            }
                            
                            .frame(width: UIScreen.main.bounds.size.width-30)
                            .frame(height: 58)
                            .background(Color(hex: 0x222141, alpha: 1))
                            .cornerRadius(15)
                            .padding(.top,25)
                            
                            
                            
                            HStack {
                                
                                
                                HStack {
                                    
                                    Text("Choose Resolution")
                                        .foregroundColor(.white)
                                        .font(Font.system(size: 17, weight: .regular, design: .default))
                                        .multilineTextAlignment(.leading)
                                    
                                    Spacer()
                                    
                                    Picker("Resolution:", selection: $selectedResolution) {
                                        ForEach(Resolution.allValues, id: \.self) { item in
                                            Text("\(item.rawValue)")
                                                .tag(item)
                                        }
                                        
                                        
                                    }.tint(.white)
                                    
                                }.padding(.horizontal,12)
                                
                                
                            }
                            
                            .frame(width: UIScreen.main.bounds.size.width-30)
                            .frame(height: 58)
                            .background(Color(hex: 0x222141, alpha: 1))
                            .cornerRadius(15)
                            .padding(.top,25)
                            
                            //Promt
                            HStack {
                                
                                HStack {
                                    
                                    Button {
                                        
                                        isFocused = false
                                                                              
                                      
                                      guard self.token != 0 else {
                                        isIAPOpened =  true
                                        return ShowIAP = true
                                      }
                                        
                                        if(text.isEmpty){
                                            showingAlert = true
                                            return
                                        }
                                        
                                        isPresented.toggle()
                                        
                                    }
                                    
                                label: {
                                    Image("Create")
                                        .resizable()
                                        .frame(width: 150)
                                        .frame(height: 49)
                                }
                                    
                                    
                                }.padding(10)
                                
                                
                            }
                            .background(Color(hex: 0x222141, alpha: 1))
                            .cornerRadius(20)
                            .padding(.top,25)
                            
                        }
                        .padding()
                        .padding(.top,10)
                    }
                    )}
                // .background(Color.clear)
                
                .offset(y: -keyboardHeight/3)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                        if let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                            keyboardHeight = keyboardSize.height
                        }
                    }
                    
                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                        keyboardHeight = 0
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self)
                }
                

                .sheet(isPresented: $showSubscriptionView, content: {
                    
                    PaywallView()
                })
                
            }
            .overlay(content: {
                if ShowIAP {
                    InAppPurchases(close: $ShowIAP).padding(.top,10)
                }
                
                
                if viewModel.isLoading {
                    Loading()
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
            
        }
        
        .onChange(of: initDismiss, perform: { newValue in
            if initDismiss {
                dismiss()
            }
        })
        
        .fullScreenCover(isPresented: $isPresented, content: {
            ImageView(initDismiss: $initDismiss, text: promtToadd, itemLocal: itemLocal)
        })
        
        
        
        
        
        
        
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
    }
}


struct GenerateView_Previews: PreviewProvider {
    static var previews: some View {
        GenerateView()
            .environmentObject(SettingsViewModel())
    }
}


enum Style : String {
    case digitalArt = "HD"
    case cartoon = "Standard"
    case realistic = "Low Res."
    case oilPainting = "HDR"
    
    static let allValues = [digitalArt, cartoon, realistic, oilPainting]
}

enum Resolution : String {
    case _256 = "256x256"
    case _512 = "512x512"
    case _1024 = "1024x1024"
    
    static let allValues = [_1024,_512,_256]
}


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif




extension UIResponder {
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
    
    private static weak var _currentFirstResponder: UIResponder?
    
    @objc private func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
    
    var globalFrame: CGRect? {
        guard let view = self as? UIView else { return nil }
        return view.superview?.convert(view.frame, to: nil)
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var bottomPadding: CGFloat = 0
    
    func body(content: Content) -> some View {
        // 1.
        GeometryReader { geometry in
            content
                .padding(.bottom, self.bottomPadding)
            // 2.
                .onReceive(Publishers.keyboardHeight) { keyboardHeight in
                    // 3.
                    let keyboardTop = geometry.frame(in: .global).height - keyboardHeight
                    // 4.
                    let focusedTextInputBottom = UIResponder.currentFirstResponder?.globalFrame?.maxY ?? 0
                    // 5.
                    self.bottomPadding = max(0, focusedTextInputBottom - keyboardTop - geometry.safeAreaInsets.bottom)
                }
            // 6.
                .animation(.easeOut(duration: 0.16))
        }
    }
}
