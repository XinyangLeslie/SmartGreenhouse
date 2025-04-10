import Foundation

struct ImageItem: Identifiable, Codable {
    let id = UUID()
    let filename: String
    let url: String

    private enum CodingKeys: String, CodingKey {
        case filename, url
    }
}
