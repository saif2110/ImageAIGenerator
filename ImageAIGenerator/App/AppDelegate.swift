//
//  AppDelegate.swift
//  ImageAIGenerator
//
//  Created by Admin on 30.07.2023.
//

import SwiftUI
import UIKit
import RevenueCat


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        
        //#if DEBUG
        //        SwiftyStoreKit.shouldAddStorePaymentHandler = { payment, product in
        //            return true
        //        }
        //#endif
        //
        //        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
        //            for purchase in purchases {
        //                switch purchase.transaction.transactionState {
        //                case .purchased, .restored:
        //                    if purchase.needsFinishTransaction {
        //                        // Deliver content from server, then:
        //                        SwiftyStoreKit.finishTransaction(purchase.transaction)
        //                    }
        //                    // Unlock content
        //                    AppUserDefaults.paymentId = purchase.productId
        //                    AppUserDefaults.isPremiumUser = true
        //                case .failed, .purchasing, .deferred:
        //                    //                    AppUserDefaults.isPremiumUser = false
        //                    break // do nothing
        //                @unknown default: break
        //
        //                }
        //            }
        //        }
        
        Purchases.logLevel = .error
        Purchases.configure(withAPIKey: "appl_ApjmvDwhYmKluoyLqMjXeaBuicl")
        Purchases.shared.delegate = self
        
        isSubsActive()
        
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
