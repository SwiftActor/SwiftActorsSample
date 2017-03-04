import Foundation
import Himotoki

struct City: Decodable {
    let id: Int
    let name: String
    let coord: [String: Double]

    static func decode(_ e: Extractor) throws -> City {
        return try City(
            id: e <| "id",
            name: e <| "name",
            coord:  e <|-| ["coord"]
        )
    }
}
