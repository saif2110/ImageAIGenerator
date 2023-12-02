
import Foundation
import UIKit

struct AppUserDefaults{
    
//    @UserDefault("appThemeColor", defaultValue: "")
//    static var appThemeColor: String
//    
//    @UserDefault("preferredTheme", defaultValue: 0)
//    static var preferredTheme: Int
//    
    @UserDefault("preferredLanguage", defaultValue: "en")
    static var preferredLanguage: String
    
    @UserDefault("shouldshowLocalNotification", defaultValue: false)
    static var shouldshowLocalNotification: Bool
    
    @UserDefault("isOnboarding", defaultValue: true)
    static var isOnboarding: Bool
    
    @UserDefault("isFirstUse", defaultValue: true)
    static var isFirstUse: Bool
    
    @UserDefault("reminderDate", defaultValue: 0.0)
    static var reminderDate: Double
    
    @UserDefault("shouldShowInitScreen", defaultValue: true)
    static var shouldShowInitScreen: Bool
    
    @UserDefault("shouldShowWelcomeScreen", defaultValue: true)
    static var shouldShowWelcomeScreen: Bool
    
    @UserDefault("paymentId", defaultValue: "")
    static var paymentId: String
    
    @UserDefault("isPremiumUser", defaultValue: false)
    static var isPremiumUser: Bool
    
    @UserDefault("shouldShowPaymentScreen", defaultValue: true)
    static var shouldShowPaymentScreen: Bool
    
    @UserDefault("counter", defaultValue: 0)
    static var counter: Int
    
    @UserDefault("preferredFuelType", defaultValue: 0)
    static var preferredFuelType: Int
    
    @UserDefault("appStartUpsCountKey", defaultValue: 0)
    static var appStartUpsCountKey: Int
    
    @UserDefault("lastVersionPromptedForReviewKey", defaultValue: "")
    static var lastVersionPromptedForReviewKey: String
    
    @UserDefault("credit", defaultValue: 0)
    static var credit: Int
}


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T){
        self.key = key
        self.defaultValue = defaultValue
    }
     
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}






class PhotoManager {
    static let shared = PhotoManager()
    
    private let photoKey = "savedPhotos"
    
    private init() {}
    
    func savePhoto(_ photo: UIImage) {
        // Retrieve the existing array of Data from UserDefaults
        var existingPhotoDataArray = UserDefaults.standard.array(forKey: photoKey) as? [Data] ?? []
        
        // Convert UIImage to Data and append to the array
        let photoData = photo.pngData()!
        existingPhotoDataArray.append(photoData)
        
        // Save the updated array to UserDefaults
        UserDefaults.standard.set(existingPhotoDataArray, forKey: photoKey)
    }
    
    func retrievePhotos() -> [UIImage]? {
        // Retrieve the array of Data from UserDefaults
        guard let photoDataArray = UserDefaults.standard.value(forKey: photoKey) as? [Data] else {
            return nil
        }
        
        // Convert Data back to UIImage
        let retrievedPhotos = photoDataArray.map { UIImage(data: $0)! }
        return retrievedPhotos
    }
}
