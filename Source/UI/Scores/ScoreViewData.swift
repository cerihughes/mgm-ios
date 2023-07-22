import UIKit

protocol ScoreViewData: AlbumArtViewData {
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

struct ScoreViewDataImplementation: ScoreViewData {
    let loadingImage: UIImage?
    private let album: Album
    private let index: Int
    let position: String
    private let award: Award

    init(album: Album, index: Int, position: String) {
        loadingImage = index.rotatingLoadingImage
        self.album = album
        self.index = index
        self.position = position
        award = Award.award(for: album.score ?? 0.0)
    }

    var images: [Image]? {
        album.images
    }

    var albumName: String {
        album.name
    }

    var artistName: String {
        album.artist
    }

    var rating: String {
        guard let score = album.score else { return "" }
        return String(format: "%.01f", score)
    }

    var ratingFontColor: UIColor {
        award.ratingFontColor
    }

    var awardImage: UIImage? {
        award.awardImage
    }

    var spotifyURL: URL? {
        guard let spotifyID = album.spotifyId else { return nil }
        return .createSpotifyAlbumURL(albumID: spotifyID)
    }
}
