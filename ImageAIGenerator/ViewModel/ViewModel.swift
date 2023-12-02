import Foundation
import UIKit
import Alamofire

final class ViewModel: ObservableObject {
    private let urlSession: URLSession
    @Published var imageURL: URL?
    @Published var isLoading = false
    @Published var isEditedClick:Bool = false
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func generateImage(withText text: String) async {
        guard let url = URL(string: "https://apps15.com/ArtMaker/makeImage.php") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(AppConfig.OPEN_AI_API_KEY)", forHTTPHeaderField: "Authorization")
        
        let dictionary: [String: Any] = [
            "n": 1,
            "size": "1024x1024",
            "prompt": text
        ]
        
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let (data, _) = try await urlSession.data(for: urlRequest)
            let model = try JSONDecoder().decode(ModelResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.isLoading = false
                guard let firstModel = model.data?.first else {
                    return
                }
                self.imageURL = URL(string: firstModel.url ?? "")
                print(self.imageURL ?? "No imageURL")
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func generateImage(withText text: String,withText resolution: String) async {
        guard let url = URL(string: "https://apps15.com/ArtMaker/makeImage.php") else {
            return
        }
        
      //  print(text,resolution)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(AppConfig.OPEN_AI_API_KEY)", forHTTPHeaderField: "Authorization")
        
        let dictionary: [String: Any] = [
            "n": 1,
            "size": resolution,
            "prompt": text
        ]
        
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let (data, _) = try await urlSession.data(for: urlRequest)
            let model = try JSONDecoder().decode(ModelResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.isLoading = false
                guard let firstModel = model.data?.first else {
                    return
                }
                self.imageURL = URL(string: firstModel.url ?? "")
                print(self.imageURL ?? "No imageURL")
            }
            
        }catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
    }
    
    func saveImageGallery() {
        guard let imageURL = imageURL else {
            return
        }
        
        DispatchQueue.global(qos: .userInteractive).async {
            let data = try! Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                let image = UIImage(data: data)!
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
    
    func generateEdit(withText text: String, imageData: Data, maskData: Data) {
        let url = URL(string: "https://apps15.com/ArtMaker/edit.php")!
        
        let headers = HTTPHeaders(["Authorization" : "Bearer \(AppConfig.OPEN_AI_API_KEY)"])
        
        let dictionary = [
            "n": "1",
            "size": "1024x1024",
            "prompt": text
        ]
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in dictionary {
                if let data = value.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
            multipartFormData.append(maskData, withName: "mask", fileName: "mask.png", mimeType: "image/png")
            
        }, to: url, headers: headers)
        .responseDecodable(of: ModelResponse.self) { dataResponse in
            let model = try! JSONDecoder().decode(ModelResponse.self, from: dataResponse.data!)
            
            DispatchQueue.main.async {
                self.isLoading = false
                guard let firstModel = model.data?.first else {
                    return
                }
                self.imageURL = URL(string: firstModel.url ?? "")
                print(self.imageURL ?? "No imageURL")
            }
        }
        
    }
}
