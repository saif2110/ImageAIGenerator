//
//  CreditPlanView.swift
//  ImageAIGenerator
//
//  Created by Asil Arslan on 30.08.2023.
//

import SwiftUI
import StoreKit

struct CreditPlanView: View {
    
    @EnvironmentObject var paymentViewModel: PaymentViewModel
    @Binding var selectedCredit: Product
    let credit: Product
    let onPurchase: (Product) -> Void
    
    var body: some View {
        ZStack {
            HStack(spacing: 16) {
                if selectedCredit == credit {
                    Image.checkmarkCircleIcon
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.darkOrange)
                } else {
                    Image.circleIcon
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.darkOrange)
                }
                
                Text(credit.displayName)
                    .font(.system(size: 20, weight: .semibold))
                
                
                Spacer()
                
                Text(credit.displayPrice)
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .padding(.horizontal, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedCredit == credit ? Color.darkOrange : Color.clear, lineWidth: 4)
            )
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            VStack {
                HStack {
                    Spacer()
//                    Text("Save \(String(format: "%.2f", paymentViewModel.saveValue(product: selectedCredit)))%")
                    Text("Save \(paymentViewModel.saveValue(product: selectedCredit))%")
                        .font(.system(size: 14, weight: .medium))
                        .padding(8)
                        .background(Color.darkOrange)
                        .foregroundColor(.white)
                        .cornerRadius(6)
//                        .opacity(selectedCredit == credit ? 1 : 0)
                        .opacity((selectedCredit == credit && paymentViewModel.saveValue(product: selectedCredit) != 0) ? 1 : 0)
                }.padding(.horizontal, 40).padding(.top, -12)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
        }
        .onTapGesture {
            paymentViewModel.selectedCredit = credit
            selectedCredit = credit
    }
    }
}

//struct CreditPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditPlanView(selectedPlan: .constant(.yearly), paymentId: AppConfig.MONTHLY_PRODUCT_ID)
//    }
//}
