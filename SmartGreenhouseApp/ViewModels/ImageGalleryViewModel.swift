
import Foundation

struct DetectionImage: Identifiable, Codable {
    let id = UUID()
    let filename: String
    let url: String
}

class ImageGalleryViewModel: ObservableObject {
    @Published var images: [DetectionImage] = []

    func fetchImages() {
        guard let url = URL(string: "http://\(Config.serverIP):5001/api/images") else {
            print("❌ Invalid image API URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching images: \(error)")
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(ImageResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.images = response.data
                    }
                } catch {
                    print("❌ Failed to decode image JSON: \(error)")
                }
            }
        }.resume()
    }
}

struct ImageResponse: Codable {
    let success: Bool
    let data: [DetectionImage]
}
