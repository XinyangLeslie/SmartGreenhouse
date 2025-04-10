
import Foundation

class ImageListViewModel: ObservableObject {
    @Published var images: [ImageItem] = []

    func fetchImages() {
        guard let url = URL(string: "http://\(Config.serverIP):5001/api/images") else {
            print("❌ Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Request failed: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(ResponseWrapper.self, from: data)
                DispatchQueue.main.async {
                    self.images = decoded.data
                }
            } catch {
                print("❌ JSON decode error: \(error)")
            }

        }.resume()
    }
}

// 用于解析整体 JSON
struct ResponseWrapper: Codable {
    let success: Bool
    let data: [ImageItem]
}
