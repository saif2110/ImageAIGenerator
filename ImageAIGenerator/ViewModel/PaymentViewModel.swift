
import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

class PaymentViewModel: ObservableObject{
    @Published var isLoadingRetrieveProducts = false
    
    @Published var isLoadingPayment = false
    
    @Published var showAlert = false
    @Published var title: String = ""
    @Published var payments = [Payment]()
    @Published var selectedProductId: String = ""
    @Published var selectedPayment: Payment?
    @Published var selectedCredit: Product?
    
    @Published private(set) var credit: [Product]
    
    var updateListenerTask: Task<Void, Error>? = nil
    
    private let productIdToEmoji: [String: Int]
    
    init(){
        
        productIdToEmoji = PaymentViewModel.loadProductIdToEmojiData()
        
        credit = []
        
        //Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactions()

        Task {
            //During store initialization, request products from the App Store.
            await requestProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    static func loadProductIdToEmojiData() -> [String: Int] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: Int] else {
            return [:]
        }
        return data
    }
    
    
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //Iterate through any transactions that don't come from a direct call to `purchase()`.
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a transaction that fails verification. Don't deliver content to the user.
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    
    @MainActor
    func requestProducts() async {
        do {
            //Request products from the App Store using the identifiers that the Products.plist file defines.
            let storeProducts = try await Product.products(for: productIdToEmoji.keys)

            var newCredit: [Product] = []

            //Filter the products into categories based on their type.
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newCredit.append(product)
                case .nonConsumable: break
//                    newCars.append(product)
                case .autoRenewable: break
//                    newSubscriptions.append(product)
                case .nonRenewable: break
//                    newNonRenewables.append(product)
                default:
                    //Ignore this product.
                    print("Unknown product")
                }
            }
            
            credit = sortByPrice(newCredit)
            
            if credit.count > 0 {
                selectedCredit = credit.first!
            }
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> Transaction? {
        //Begin purchasing the `Product` the user selects.
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            //Check whether the transaction is verified. If it isn't,
            //this function rethrows the verification error.
            let transaction = try checkVerified(verification)

            //Always finish a transaction.
            await transaction.finish()

            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //Check whether the JWS passes StoreKit verification.
        switch result {
        case .unverified:
            //StoreKit parses the JWS, but it fails verification.
            throw StoreError.failedVerification
        case .verified(let safe):
            //The result is verified. Return the unwrapped value.
            return safe
        }
    }

    func credit(for productId: String) -> Int {
        return productIdToEmoji[productId]!
    }

    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }


    private func showAlert(title: String){
        self.title = title
        self.showAlert = true
    }
    
    func saveValue(product: Product) -> Decimal{
        var singleCredit: Decimal = 0
        var selectedCredits: Decimal = 0
        if credit.count > 0 {
            singleCredit = credit.first!.price
            selectedCredits = product.price
        }
        let save = 100 * (singleCredit - selectedCredits / Decimal(credit(for: product.id))) / singleCredit
        print(save)
        return save
    }
    
    func saveValue(product: Product) -> String{
        var singleCredit: Decimal = 0
        var selectedCredits: Decimal = 0
        if credit.count > 0 {
            singleCredit = credit.first!.price
            selectedCredits = product.price
        }
        let save = 100 * (singleCredit - selectedCredits / Decimal(credit(for: product.id))) / singleCredit
        print(save)
        return save.formattedAmount ?? ""
    }
    
}

struct PaymentResult{
    var success: Bool
    var error:String?
}

extension Decimal {
    var formattedAmount: String? {
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: self as NSDecimalNumber)
    }
}


struct PaymentErrorHandler{
    static func map(from error: SKError) -> String? {
        var errorDescription : String? = nil
        switch error.code {
        case .unknown:
            errorDescription = "Unknown error. Please contact support"
        case .clientInvalid:
            errorDescription = "Not allowed to make the payment"
        case .paymentCancelled:
            errorDescription = "Payment cancelled"
        case .paymentInvalid:
            errorDescription = "The purchase identifier was invalid"
        case .paymentNotAllowed:
            errorDescription = "The device is not allowed to make the payment"
        case .storeProductNotAvailable:
            errorDescription = "The product is not available in the current storefront"
        case .cloudServicePermissionDenied:
            errorDescription = "Access to cloud service information is not allowed"
        case .cloudServiceNetworkConnectionFailed:
            errorDescription = "Could not connect to the network"
        case .cloudServiceRevoked:
            errorDescription = "User has revoked permission to use this cloud service"
        default:
            errorDescription = (error as NSError).localizedDescription
        }
        return errorDescription
    }
}


extension String{
    var localized: String {
        return NSLocalizedString(self, comment: "\(self)_comment")
    }
}



struct Payment: Identifiable{
    let id = UUID()
    let paymentId: String
    var title: String
    var index: Int
    var price: Double = 0
    var priceLocale: String
    var discount: String
    var extraInfo: String
    var unit: String
    var duration: String
    var locale: Locale = Locale.current
    var isTrialAvailable = false
    var trialPrice = ""
    var currency = "USD"
    
    init(paymentId: String, title: String, index: Int, price: String, discount: String, extraInfo: String, unit: String, duration: String){
        self.paymentId = paymentId
        self.title = title
        self.index = index
        self.priceLocale = price
        self.discount = discount
        self.extraInfo = extraInfo
        self.unit = unit
        self.duration = duration
    }
}

extension Payment{

    func monthlyPrice() -> String{
        let monthly: Double = price/12
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: monthly as NSNumber)!
    }

}
