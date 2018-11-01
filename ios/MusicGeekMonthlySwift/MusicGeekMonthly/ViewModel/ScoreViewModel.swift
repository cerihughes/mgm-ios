import UIKit

protocol ScoreViewModel {
    /// The album name
    var albumName: String {get}

    /// The artist name
    var artistName: String {get}

    /// An image to represent the restaurant's rating
    var ratingImage: UIImage? {get}

    /// Loads an album cover. Image data will be passed into the given completion block
    ///
    /// - Parameter completion: the completion block
    func loadAlbumCover(_ completion: @escaping (UIImage?) -> Void)

    /// Cancels any ongoing image load.
    func cancelLoadAlbumCover()
}

fileprivate let musicBrainzImageURLFormat = "http://coverartarchive.org/release/%@/front-250.jpg"

final class ScoreViewModelImplementation: NSObject, ScoreViewModel {
    private let imageLoader: ImageLoader
    private let album: Album

    private var dataLoaderToken: DataLoaderToken? = nil

    init(imageLoader: ImageLoader, album: Album) {
        self.imageLoader = imageLoader
        self.album = album
    }

    var albumName: String {
        return album.name
    }

    var artistName: String {
        return album.artist
    }

    var ratingImage: UIImage? {
        return nil
    }

    func loadAlbumCover(_ completion: @escaping (UIImage?) -> Void) {
        let urlString = String(format: musicBrainzImageURLFormat, album.MBID)
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        dataLoaderToken = imageLoader.loadImage(url: url) { (response) in
            DispatchQueue.main.async {
                switch (response) {
                case .success(let image):
                    completion(image)
                case .failure(_):
                    completion(nil)
                }
            }
        }
    }

    func cancelLoadAlbumCover() {
        dataLoaderToken?.cancel()
        dataLoaderToken = nil
    }
}
