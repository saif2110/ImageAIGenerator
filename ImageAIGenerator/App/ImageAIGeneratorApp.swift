//
//  ImageAIGeneratorApp.swift
//  ImageAIGenerator
//
//  Created by Home on 10/11/22.
//

import SwiftUI
import RevenueCat


@main
struct ImageAIGeneratorApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var paymentViewModel = PaymentViewModel()
    @StateObject var settingsViewModel = SettingsViewModel()
    
    init(){
        
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleFont = UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)?
                .withSymbolicTraits(.traitBold)
            ??
            titleFont.fontDescriptor
            , size: titleFont.pointSize)
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
        
        
        UITableView.appearance().showsVerticalScrollIndicator = false
        
        
    }
    
    @AppStorage("isWelcomePageShown") var isWelcomePageShown: Bool = false
    
    var body: some Scene {
        WindowGroup {
            
            if isWelcomePageShown {
                ContentView()
            }else{
                WelcomePages()
            }
          
            
            // WelcomePages()
           // ContentView()
            //EditView()
            
          // homeView()
           // GenerateView()
//            ContentView()
//                .environmentObject(paymentViewModel)
//                .environmentObject(settingsViewModel)
        }
    }
}
