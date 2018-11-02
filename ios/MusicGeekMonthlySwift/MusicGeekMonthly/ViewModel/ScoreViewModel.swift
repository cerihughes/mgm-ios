import UIKit

protocol ScoreViewModel {
    /// The album name
    var albumName: String {get}

    /// The artist name
    var artistName: String {get}

    /// An image to represent the restaurant's rating
    var ratingImage: UIImage? {get}

    /// An image to show while the album art is loading
    var loadingImage: UIImage? {get}

    /// Loads an album cover. Image data will be passed into the given completion block
    ///
    /// - Parameter largestDimension: the largest dimension of the image to load (the loaded
    ///                               image can be larger or smaller - this is just a guide)
    /// - Parameter completion: the completion block
    func loadAlbumCover(largestDimension: Int, _ completion: @escaping (UIImage?) -> Void)

    /// Cancels any ongoing image load.
    func cancelLoadAlbumCover()
}

extension ScoreViewModel {
    func loadAlbumCover(_ completion: @escaping (UIImage?) -> Void) {
        loadAlbumCover(largestDimension: 250, completion)
    }
}

fileprivate let spotifyImageURLFormat = "https://i.scdn.co/image/%@"

final class ScoreViewModelImplementation: NSObject, ScoreViewModel {
    private let imageLoader: ImageLoader
    private let album: Album
    private let index: Int

    private var dataLoaderToken: DataLoaderToken? = nil

    init(imageLoader: ImageLoader, album: Album, index: Int) {
        self.imageLoader = imageLoader
        self.album = album
        self.index = index
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

    var loadingImage: UIImage? {
        let suffix = (index % 3) + 1
        let imageName = "album\(suffix)"
        return UIImage(named: imageName)
    }

    func loadAlbumCover(largestDimension: Int, _ completion: @escaping (UIImage?) -> Void) {
        guard let imageID = album.images.image(for: largestDimension) else {
            return
        }

        let urlString = String(format: spotifyImageURLFormat, imageID)
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
