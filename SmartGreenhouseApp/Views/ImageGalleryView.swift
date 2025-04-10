import SwiftUI

// 假设你的 ImageGalleryView 已经定义好
struct ImageGalleryView: View {
    @StateObject var viewModel = ImageGalleryViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.images) { image in
                        VStack {
                            Text(image.filename)
                                .font(.caption)
                                .padding(.bottom, 2)

                            AsyncImage(url: URL(string: image.url)) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 300)
                                case .failure:
                                    Image(systemName: "exclamationmark.triangle")
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .padding(.bottom)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Detection Gallery")
        }
        .onAppear {
            viewModel.fetchImages()
        }
    }
}
