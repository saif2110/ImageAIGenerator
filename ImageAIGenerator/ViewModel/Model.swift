// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let modelResponse = try? JSONDecoder().decode(ModelResponse.self, from: jsonData)

import Foundation
import OptionallyDecodable // https://github.com/idrougge/OptionallyDecodable

// MARK: - ModelResponse
struct ModelResponse: Codable {
    let created: Int?
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let url: String?
}
