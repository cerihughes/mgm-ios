import UIKit

protocol ScoreViewModel: AlbumArtViewModel {
    /// The album name
    var albumName: String { get }

    /// The artist name
    var artistName: String { get }

    // The album rating, to 1 decimal place
    var rating: String { get }

    // The colour of the rating text
    var ratingFontColor: UIColor { get }

    /// An image to represent the restaurant's rating award
    var awardImage: UIImage? { get }

    /// The "chart" position
    var position: String { get }

    /// The spotify URL to navigate to on interaction
    var spotifyURL: URL? { get }
}

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

final class ScoreViewModelImplementation: AlbumArtViewModelImplementation, ScoreViewModel {
    private let album: Album
    private let index: Int
    internal let position: String
    private let award: Award

    init(imageLoader: ImageLoader, album: Album, index: Int, position: String) {
        self.album = album
        self.index = index
        self.position = position
        award = Award.award(for: album.score ?? 0.0)

        super.init(imageLoader: imageLoader, images: album.images, loadingImageIndex: (index % 3) + 1)
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

    var spotifyURL: URL? {
        guard let spotifyID = album.spotifyId else {
            return nil
        }
        return .createSpotifyAlbumURL(albumID: spotifyID)
    }
}

extension UIColor {
    static var mgm_gold = UIColor(red: 238.0 / 255.0, green: 187.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    static var mgm_silver = UIColor(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    static var mgm_bronze = UIColor(red: 217.0 / 255.0, green: 162.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    static var mgm_green = UIColor(red: 55.0 / 255.0, green: 106.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
}
