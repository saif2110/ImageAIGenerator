//
//  AppDelegate.swift
//  ImageAIGenerator
//
//  Created by Admin on 30.07.2023.
//

import SwiftUI
import UIKit


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

        
        return true
    }
}

