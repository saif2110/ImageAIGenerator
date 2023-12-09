
import Foundation
import UIKit
import SwiftUI


struct AppUserDefaults{
  
  
  
  //    @UserDefault("appThemeColor", defaultValue: "")
  //    static var appThemeColor: String
  //
  //    @UserDefault("preferredTheme", defaultValue: 0)
  //    static var preferredTheme: Int
  
  @UserDefault("AppOpend", defaultValue: 0)
  static var AppOpend: Int
  
  
  @UserDefault("AppUsed", defaultValue: 0)
  static var AppUsed: Int
  
  @UserDefault("isPRO", defaultValue: false)
  static var isPRO: Bool
  
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





//
//class PhotoManager {
//    static let shared = PhotoManager()
//
//    private let photoKey = "savedPhotos"
//
//    private init() {}
//
//    func savePhoto(_ photo: UIImage) {
//        // Retrieve the existing array of Data from UserDefaults
//        var existingPhotoDataArray = UserDefaults.standard.array(forKey: photoKey) as? [Data] ?? []
//
//        // Convert UIImage to Data and append to the array
//        guard let photoData = photo.pngData() else {
//            print("Error: Unable to convert UIImage to Data.")
//            return
//        }
//
//        existingPhotoDataArray.append(photoData)
//
//        // Save the updated array to UserDefaults
//        UserDefaults.standard.set(existingPhotoDataArray, forKey: photoKey)
//
//    }
//
//    func retrievePhotos() -> [UIImage]? {
//        // Retrieve the array of Data from UserDefaults
//        guard let photoDataArray = UserDefaults.standard.value(forKey: photoKey) as? [Data] else {
//            return nil
//        }
//
//        // Convert Data back to UIImage
//        let retrievedPhotos = photoDataArray.compactMap { UIImage(data: $0) }
//        return retrievedPhotos
//    }
//}


extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    static func saveImageToDocumentsDirectory(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }

        let fileName = UUID().uuidString
        let documentsURL = getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            try data.write(to: fileURL, options: .atomic)
            print("Image saved to documents directory with filename: \(fileName)")
            return fileName
        } catch {
            print("Unable to save image to documents directory. Error: \(error.localizedDescription)")
            return nil
        }
    }

    static func loadAllImagesFromDocumentsDirectory() -> [UIImage] {
        let documentsURL = getDocumentsDirectory()

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let images = fileURLs.compactMap { (fileURL) -> UIImage? in
                if let imageData = try? Data(contentsOf: fileURL),
                   let image = UIImage(data: imageData) {
                    return image
                }
                return nil
            }
            return images
        } catch {
            print("Error while loading images from documents directory: \(error.localizedDescription)")
            return []
        }
    }
}

class ImageManager {
    func saveImage(image: UIImage) {
        // Save the image and get the generated filename
        if let fileName = FileManager.saveImageToDocumentsDirectory(image: image) {
            // Now you can use the fileName to retrieve the image later
            print("Generated filename for the saved image: \(fileName)")
        }
    }

    func loadAllImagesFromDocumentDirectory() -> [UIImage] {
        return FileManager.loadAllImagesFromDocumentsDirectory()
    }
}
