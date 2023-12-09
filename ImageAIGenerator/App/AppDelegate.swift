//
//  AppDelegate.swift
//  ImageAIGenerator
//
//  Created by Admin on 30.07.2023.
//

import SwiftUI
import UIKit
import RevenueCat
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
  @AppStorage("AIGTK") var token: Int = 0
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    Purchases.logLevel = .error
    Purchases.configure(withAPIKey: "appl_ApjmvDwhYmKluoyLqMjXeaBuicl")
    Purchases.shared.delegate = self
    
    isSubsActive()
    
    FirebaseApp.configure()
    
    if AppUserDefaults.AppOpend == 0 {
      token = 3
    }
    
    AppUserDefaults.AppOpend += 1
    
    return true
  }
  
  
  
}

func isSubsActive(){
  
  Purchases.shared.getCustomerInfo { (purchaserInfo, error) in
    
    if !(purchaserInfo?.entitlements.active.isEmpty ?? false) {
      AppUserDefaults.isPRO = true
    }else{
      AppUserDefaults.isPRO = false
    }
  }
}


extension AppDelegate: PurchasesDelegate {
  func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
    /// - handle any changes to the user's CustomerInfo
  }
}
