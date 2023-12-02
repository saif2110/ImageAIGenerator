//
//  homeView.swift
//  ImageAIGenerator
//
//  Created by Admin on 24/11/23.
//

import SwiftUI

struct homeView: View {
    @StateObject var viewModel = ViewModel()
    @State var Prompt:String = "Enter Prompt"
    @FocusState var isFocused: Bool
    @State private var isPresented = false
    let items: [String] = ["Anime", "Cartoon", "Gothic", "Impressionist", "Oil", "Origami", "realistic", "Surrealistic", "Watercolor"]
    
    @State var itemLocal:String = ""
    
    @State var showError:Bool = false
    
    @State var errorText = "Dear user, please choose the desired art style from the options below."
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader {_ in
            ZStack {
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                VStack {
                    
                    VStack {
                        HStack{
                            Text("Create Your Art")
                                .font(Font.system(size: 30, weight: .black, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        HStack {
                            
                            
                            HStack {
                                TextField(Prompt, text: $Prompt)
                                    .focused($isFocused)
                                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
                                    .multilineTextAlignment(.leading)
                                //.scrollContentBackground(.hidden)
                                    .foregroundColor(.white)
                                
                                    .frame(height: 61)
                                    .multilineTextAlignment(.center)
                                
                                    .onTapGesture {
                                        if Prompt == "Enter Prompt" {
                                            Prompt = ""
                                            isFocused = true
                                        }
                                        
                                        
                                        //                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                        //                                        isFocused = false
                                        //                                    }
                                        
                                    }
                                
                                Button {
                                    
                                    guard Prompt != "", Prompt != "Enter Prompt",Prompt.count > 5 else {
                                        errorText = "Please enter a prompt to obtain the desired image. (Minimum words require is 3)"
                                        showError = true
                                        return
                                    }
                                    
                                    
                                    if itemLocal == "" {
                                        errorText = "Dear user, please choose the desired art style from the options below."
                                        showError = true
                                    }else{
                                        
                                        //Good to go
                                        isFocused = false
                                        showError = false
                                        isPresented.toggle()
                                    }
                                    
                                    
                                    
                                    
                                } label: {
                                    Image("Create")
                                        .resizable()
                                        .frame(width: 105)
                                        .frame(height: 35)
                                }
                                .fullScreenCover(isPresented: $isPresented) {
                                    GenerateView(itemLocal: itemLocal,promtToadd: Prompt)
                                }
                                
                            }.padding(.horizontal,12)
                            
                            
                        }
                        .background(Color(hex: 0x222141, alpha: 1))
                        .cornerRadius(15)
                        .padding(.top,10)
                        
                    }
                    
                    if showError {
                        Text(errorText)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    
                    
                    Rectangle().fill(.clear).frame(height: 10)
                    
                    Button {
                        
                    } label: {
                        Image("offer")
                            .resizable()
                            .frame(height: 110)
                    }
                    
                    Rectangle().fill(.clear).frame(height: 6)
                    
                    ScrollView(showsIndicators: false) {
                        
                        HStack{
                            Text("Art Style")
                                .font(Font.system(size: 30, weight: .black, design: .default))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        
                        LazyVGrid(columns: columns,spacing: 23) {
                            ForEach(items, id: \.self) { item in
                                
                                
                                let scale = itemLocal == item ? 1.2 : 1
                                
                                Image(item)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .background(Color.clear)
                                    .scaleEffect(x: scale, y: scale)
                                    .padding(.horizontal,3)
                                
                                    .onTapGesture {
                                        vibarate()
                                        itemLocal = item
                                        
                                    }
                                
                                
                            }
                            
                            
                            Rectangle().fill(.clear).frame(height: 150)
                            
                        }
                        
                        
                    }
                    
                    
                    
                    Spacer()
                    
                    
                }
                .padding(.horizontal,15)
                
                
            }
            
        }.ignoresSafeArea(.keyboard)
        
        
        
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    //                    if !AppUserDefaults.isPremiumUser {
                    Button{
                        withAnimation{
                            //  showSubscriptionView = true
                        }
                    }label: {
                        HStack(spacing:5){
                            //                                Text("\(settingsViewModel.credit) \(settingsViewModel.credit > 1 ? "Credits" : "Credit")")
                            Image(systemName: "c.circle.fill")
                                .foregroundColor(.yellow)
                            //                       // Text("\(settingsViewModel.credit)")
                            //                            .font(.callout)
                            //                            .fontWeight(.semibold)
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
                    //                            Button("Done") {
                    //                                isFocused = false
                    //                            }.frame(maxWidth: .infinity, alignment: .trailing)
                    Button(action: {
                        isFocused = false
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }).frame(maxWidth: .infinity, alignment: .trailing)
                }
                
            }

    }
    
}

struct homeView_Previews: PreviewProvider {
    static var previews: some View {
        homeView()
    }
}

struct MyTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                // .stroke(Color.red, lineWidth: 3)
            ).padding()
    }
}


func vibarate(){
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
}




struct UIViewLifeCycleHandler: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController

    var onWillAppear: () -> Void = { }

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> UIViewControllerType {
        context.coordinator
    }

    func updateUIViewController(
        _: UIViewControllerType,
        context _: UIViewControllerRepresentableContext<Self>
    ) { }

    func makeCoordinator() -> Self.Coordinator {
        Coordinator(onWillAppear: onWillAppear)
    }

    class Coordinator: UIViewControllerType {
        let onWillAppear: () -> Void

        init(onWillAppear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}


extension View {
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillAppearModifier(callback: perform))
    }
}

struct WillAppearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillAppear: callback))
    }
}
