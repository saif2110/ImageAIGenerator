

import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject var paymentViewModel: PaymentViewModel
    @EnvironmentObject var settingsViewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PremiumPlan = .yearly
    @State private var showAlert = false
    @State private var alertText = ""
    //    let iPhone14ProMaxScreenSize: CGSize = CGSize(width: 430.0, height: 932.0)
    let screenSize: CGSize = UIScreen.main.bounds.size
    
    private let privacyPolicyURL: URL = URL(string: AppConfig.PRIVACY_POLICIY_URL)!
    private let termsAndConditionsURL: URL = URL(string: AppConfig.TERMS_AND_CONDITIONS_URL)!
    
    @State var credit = AppUserDefaults.credit
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
            ScrollView(showsIndicators: false){
                VStack(alignment: .center, spacing: 16) {
                    headerSection()
                    creditsSection()
                    choosePlanSection()
                    actionButton()
//                    restorePurchasesButton()
                    privacyPolicyTermsSection()
                    Spacer()
                }
            }
            .animation(.spring(), value: selectedPlan)
        }
        .onAppear(){
            if paymentViewModel.credit.count > 0 {
                paymentViewModel.selectedCredit = paymentViewModel.credit.first!
            }
        }
    }
    
    private func headerSection() -> some View {
        return HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Image AI Generator")
                    .font(.system(size: 26, weight: .semibold, design: .rounded))
                
                Text("Credits")
                    .font(.system(size: 40, weight: .bold, design: .rounded))
            }
            Spacer()
            XMarkButton() { dismiss() }
        }
        .padding(20)
    }
    
    private func creditsSection() -> some View {
        return VStack {
//            Text("\(credit > 1 ? "Credits" : "Credit")")
//                .foregroundColor(.secondary)
//                .font(.system(size: 20, weight: .medium))
            Image(systemName: "c.circle.fill")
                .resizable()
                .foregroundColor(.yellow)
                .frame(width: 50,height: 50)
//            Text("\(credit)")
            if credit == 0 {
                Text("No Credits Available")
                        .font(.title)
                        .fontWeight(.bold)
            }else{
                Text("\(credit) \(credit > 1 ? "Credits" : "Credit")")
                    .font(.title)
                    .fontWeight(.bold)
            }
        }.padding(.leading, 30).padding(.trailing, 30)
    }
    
    private func carouselSection() -> some View {
        return VStack {
            InfiniteScroller(contentWidth: getContentWidth(), direction: .forward) {
                HStack(spacing: 16) {
                    FeatureCardView(featureCard: .unlimitedEntries)
                    FeatureCardView(featureCard: .importData)
                    FeatureCardView(featureCard: .biometricsLock)
                    FeatureCardView(featureCard: .automaticBackups)
                }.padding(8)
            }
            
            InfiniteScroller(contentWidth: getContentWidth(), direction: .backward) {
                HStack(spacing: 16) {
                    FeatureCardView(featureCard: .customTags)
                    FeatureCardView(featureCard: .moreStats)
                    FeatureCardView(featureCard: .moreDates)
                    FeatureCardView(featureCard: .unlimitedGoals)
                }.padding(8)
            }
        }
    }
    
    private func choosePlanSection() -> some View {
        return VStack(alignment: .center, spacing: 16) {
            Text("Choose a package")
                .foregroundColor(.secondary)
                .font(.system(size: 20, weight: .medium))
            //                .padding(.top)
            if paymentViewModel.credit.count > 0 {
                CreditsView(selectedCredit: paymentViewModel.credit.first!, onPurchase: { credit in
                    withAnimation {
                        //                        isFuelStoreShowing = false
                    }
                })
            }
        }
    }
    
    private func actionButton() -> some View {
        return Button {
            Task {
                await purchase()
            }
        } label: {
            Text("Continue")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
                .padding(12)
                .frame(maxWidth: .infinity)
               // .background(Color.appTheme)
                .cornerRadius(10)
                .padding(.horizontal, 24)
            
        }
        .disabled(paymentViewModel.selectedCredit == nil)
        .alert(isPresented: $showAlert){
            Alert(title: Text("Failed"), message: Text(alertText), dismissButton: .default(Text("OK")))
        }
    }
    
    @MainActor
    func purchase() async {
        do {
            if try await paymentViewModel.purchase(paymentViewModel.selectedCredit!) != nil {
                storeCredits()
                dismiss()
            }
        } catch StoreError.failedVerification {
            alertText = "Your purchase could not be verified by the App Store."
            showAlert.toggle()
//            errorTitle = "Your purchase could not be verified by the App Store."
//            isShowingError = true
        } catch {
            print("Failed fuel purchase: \(error)")
        }
    }
    
    fileprivate func storeCredits() {
        let availableCredits = AppUserDefaults.credit
        AppUserDefaults.credit = availableCredits + paymentViewModel.credit(for: paymentViewModel.selectedCredit!.id)
        credit = AppUserDefaults.credit
        settingsViewModel.setCredit()
    }
//
//    private func restorePurchasesButton() -> some View {
//        return Button {
//            //            paymentViewModel.restorePurchases{ result in
//            //                if result.success{
//            //                    settingsViewModel.setPremiumUser(paymentId: "Restore purchase")
//            //                    dismiss()
//            //                }
//            //            }
//        } label: {
//            Text("Restore Purchases")
//                .font(.system(size: 16, weight: .medium))
//                .foregroundColor(Color.appTheme)
//        }.padding(8)
//    }
    
    private func privacyPolicyTermsSection() -> some View {
        return HStack(spacing: 20) {
            Button(action: {
                UIApplication.shared.open(privacyPolicyURL, options: [:], completionHandler: nil)
            }, label: {
                Text("Privacy Policy")
            })
            Button(action: {
                UIApplication.shared.open(termsAndConditionsURL, options: [:], completionHandler: nil)
            }, label: {
                Text("Terms of Use")
            })
        }.font(.system(size: 12)).foregroundColor(.gray).padding()
    }
    

    
    private func getContentWidth() -> CGFloat {
        let cardWidth: CGFloat = 90
        let spacing: CGFloat = 16
        let padding: CGFloat = 8
        let contentWidth: CGFloat = (cardWidth * 4) + (spacing * 9) + padding
        return contentWidth
    }
    
    //    private func isIPhone14ProMax() -> Bool {
    //        return screenSize == iPhone14ProMaxScreenSize
    //    }
}



struct CreditsView: View {
    @EnvironmentObject var paymentViewModel: PaymentViewModel
    @State var selectedCredit: Product
    let onPurchase: (Product) -> Void
    
    var body: some View {
        VStack {
            ForEach(paymentViewModel.credit, id: \.id) { credit in
                CreditPlanView(selectedCredit: $selectedCredit, credit: credit , onPurchase: onPurchase).padding(.bottom, 12)
            }
        }
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        PaywallView()
    }
}


