import UIKit

protocol ScoreViewModel {
    /// The album name
    var albumName: String {get}

    /// The artist name
    var artistName: String {get}

    // The album rating, to 1 decimal place
    var rating: String {get}

    // The colour of the rating text
    var ratingFontColor: UIColor {get}

    /// An image to represent the restaurant's rating award
    var awardImage: UIImage? {get}

    /// The "chart" position
    var position: String {get}

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

fileprivate let spotifyImageURLFormat = "https://i.scdn.co/image/%@"

private enum Award {
    case gold, silver, bronze, none

    var awardImage: UIImage? {
        switch self {
        case .gold:
            return UIImage(named: "gold")
        case .silver:
            return UIImage(named: "silver")
        case .bronze:
            return UIImage(named: "plate")
        default:
            return UIImage(named: "none")
        }
    }

    var ratingFontColor: UIColor {
        switch self {
        case .gold:
            return .mgm_gold
        case .silver:
            return .mgm_silver
        case .bronze:
            return .mgm_bronze
        default:
            return .mgm_green
        }
    }

    static func award(for score: Float) -> Award {
        if score > 8.5 {
            return .gold
        }
        if score > 7.0 {
            return .silver
        }
        if score > 5.5 {
            return .bronze
        }
        return .none
    }
}

final class ScoreViewModelImplementation: NSObject, ScoreViewModel {
    private let imageLoader: ImageLoader
    private let album: Album
    private let index: Int
    private let award: Award

    private var dataLoaderToken: DataLoaderToken? = nil

    init(imageLoader: ImageLoader, album: Album, index: Int) {
        self.imageLoader = imageLoader
        self.album = album
        self.index = index
        self.award = Award.award(for: album.score ?? 0.0)
    }

    var albumName: String {
        return album.name
    }

    var artistName: String {
        return album.artist
    }

    var rating: String {
        guard let score = album.score else {
            return ""
        }
        return String(format: "%.01f", score)
    }

    var ratingFontColor: UIColor {
        return award.ratingFontColor
    }

    var awardImage: UIImage? {
        return award.awardImage
    }

    var position: String {
        return String(index + 1)
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

        var url = URL(string: imageID)
        if url?.scheme == nil {
            let urlString = String(format: spotifyImageURLFormat, imageID)
            url = URL(string: urlString)
        }

        guard let imageURL = url else {
            completion(nil)
            return
        }

        dataLoaderToken = imageLoader.loadImage(url: imageURL) { (response) in
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

extension UIColor {
    static var mgm_gold = UIColor.init(red: 238.0 / 255.0, green: 187.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    static var mgm_silver = UIColor.init(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    static var mgm_bronze = UIColor.init(red: 217.0 / 255.0, green: 162.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    static var mgm_green = UIColor.init(red: 55.0 / 255.0, green: 106.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
}
