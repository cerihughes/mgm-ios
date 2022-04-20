import UIKit

protocol AlbumArtViewData {
    /// An image to show while the album art is loading
    var loadingImage: UIImage? { get }

    /// The images associaed with this entity
    var images: [Image]? { get }
}

protocol AlbumArtViewModel {
    /// Loads an album cover. Image data will be passed into the given completion block
    ///
    /// - Parameter largestDimension: the largest dimension of the image to load (the loaded
    ///                               image can be larger or smaller - this is just a guide)
    /// - Parameter completion: the completion block
    func loadAlbumCover(largestDimension: Int, viewData: AlbumArtViewData, _ completion: @escaping (UIImage?) -> Void)

    /// Cancels any ongoing image load.
    func cancelLoadAlbumCover(viewData: AlbumArtViewData)
}

extension Int {
    var loadingImage: UIImage? {
        return rangedLoadingImage ?? Int.random(in: 1 ... 3).rangedLoadingImage
    }

    private var rangedLoadingImage: UIImage? {
        switch self {
        case 1:
            return .album1Loading
        case 2:
            return .album2Loading
        case 3:
            return .album3Loading
        default:
            return nil
        }
    }
}

class AlbumArtViewModelImplementation: AlbumArtViewModel {
    private let imageLoader: ImageLoader

    init(imageLoader: ImageLoader) {
        self.imageLoader = imageLoader
    }

    func loadAlbumCover(largestDimension: Int, viewData: AlbumArtViewData, _ completion: @escaping (UIImage?) -> Void) {
        guard
            let imageURLString = image(for: largestDimension, from: viewData),
            let imageURL = URL(string: imageURLString)
        else {
            completion(nil)
            return
        }

        _ = imageLoader.loadImage(url: imageURL) { response in
            DispatchQueue.main.async {
                switch response {
                case let .success(image):
                    completion(image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }

    func cancelLoadAlbumCover(viewData: AlbumArtViewData) {
        // TODO: Implement token tracking
    }

    // MARK: Private

    private func image(for largestDimension: Int, from viewData: AlbumArtViewData) -> String? {
        guard let images = viewData.images else { return nil }

        var candidate: String?
        for image in images {
            let size = image.size ?? 0
            if size > largestDimension {
                candidate = image.url
            } else {
                return candidate ?? image.url
            }
        }
        return candidate
    }
}
