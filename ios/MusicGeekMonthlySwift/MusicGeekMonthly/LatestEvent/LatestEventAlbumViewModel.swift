import UIKit

protocol LatestEventAlbumViewModel: AlbumArtViewModel {
    /// The album type
    var albumType: String {get}

    /// The album name
    var albumName: String {get}

    /// The artist name
    var artistName: String {get}

    // The event date
    var eventDate: String {get}

    /// The spotify album ID to navigate to on interaction
    var spotifyAlbumID: String? {get}
}

final class LatestEventAlbumViewModelImplementation: AlbumArtViewModelImplementation, LatestEventAlbumViewModel {
    private let album: Album

    init(imageLoader: ImageLoader, album: Album) {
        self.album = album

        super.init(imageLoader: imageLoader, images: album.images)
    }

    var albumType: String {
        switch album.type {
        case .classic:
            return "CLASSIC ALBUM"
        case .new:
            return "NEW ALBUM"
        }

    }

    var albumName: String {
        return album.name
    }

    var artistName: String {
        return album.artist
    }

    var eventDate: String {
        return ""
    }

    var spotifyAlbumID: String? {
        return album.spotifyID
    }
}
