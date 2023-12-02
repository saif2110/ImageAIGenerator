//
//  SettingsView.swift
//  ImageAIGenerator
//
//  Created by Admin on 30.07.2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsViewModel: SettingsViewModel
  //  @State private var themeType = AppUserDefaults.preferredTheme
    @State private var showSubscriptionFlow: Bool = false
    
    let colors: [UIColor] = [
        .systemBlue,
        .systemRed,
        .systemTeal,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemYellow
    ]
    
    var body: some View {
        NavigationView {
            Text("")
//            Form{
//
//
////                if !AppUserDefaults.isPremiumUser {
//                    Button(action: {
//                        self.showSubscriptionFlow = true
//                    }, label: {
//                        PremiumHeader()
//                    })
//                    .listRowInsets(EdgeInsets())
//                    .sheet(isPresented: $showSubscriptionFlow, content: {
//                        PaywallView()
//                    })
////                }
//
//                Section(header: Text("Preferences")){
//
//                    HStack {
//                        Text("Pick a Color")
//                        Spacer()
//                        CustomColorPicker(colors: colors, completion: { color in
//                            settingsViewModel.changeAppColor(color: color)
//                        }, showWarning: {
//                            self.showSubscriptionFlow = true
//                        })
//                    }
//
////                    ColorPicker("Pick a Color", selection:$settingsViewModel.appThemeColor.onChange(colorChange))
//
//
//                    HStack{
//                        Text("Theme")
//                        Spacer()
////                        Picker("", selection: $themeType.onChange(themeChange)){
////                            Text("System").tag(0)
////                            Text("Light").tag(1)
////                            Text("Dark").tag(2)
////                        }
//                        .fixedSize()
//                        .pickerStyle(.segmented)
//                    }
//                }
//
//                Section(header: Text("Application")){
//
//                    SettingsRowView(name: "Developer",content: AppConfig.DEVELOPER)
//                    SettingsRowView(name: "Compatibility",content: AppConfig.COMPABILITY)
//                    SettingsRowView(name: "Website", linkLabel: AppConfig.WEBSITE_LABEL, linkDestination: AppConfig.WEBSITE_LINK)
//                    SettingsRowView(name: "Version",content: "\(Bundle.main.versionNumber).\(Bundle.main.buildNumber)")
//
//                }
//            }
//            .navigationTitle("Settings")
        }
        
        // prevent iPad split view
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func themeChange(_ tag: Int){
       // settingsViewModel.changeAppTheme(theme: tag)
    }
    
    func colorChange(_ color: Color){
       // settingsViewModel.changeAppColor(color: color)
    }
}

struct SettingsLabelView: View {
    
    var labelText: String
    var labelImage: String
    
    var body: some View {
        HStack {
            Text(labelText.uppercased())
            Spacer()
            Image(systemName: labelImage )
                .font(.headline)
        }
    }
}


struct SettingsRowView: View {
    
    var name: String
    var content: String? = nil
    var linkLabel: String? = nil
    var linkDestination: String? = nil
    
    var body: some View {
        VStack {
            HStack{
                Text(LocalizedStringKey(name)).foregroundColor(.gray)
                Spacer()
                if content != nil {
                    Text(content!)
                } else if(linkLabel != nil && linkDestination != nil){
                    Link(linkLabel!, destination: URL(string: "https://\(linkDestination!)")!)
                    Image(systemName: "arrow.up.right.square").foregroundColor(.pink)
                } else {
                    EmptyView()
                }
            }
        }
    }
}


extension Bundle {
    
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    var bundleId: String {
        return bundleIdentifier!
    }
    
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
    
}

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

