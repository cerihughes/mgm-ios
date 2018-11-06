import UIKit

protocol LatestEventAlbumViewModel: AlbumArtViewModel {
    /// The album type
    var albumType: String {get}

    /// The album name
    var albumName: String {get}

    /// The "by" string
    var byString: String? {get}

    /// The artist name
    var artistName: String {get}

    /// The spotify URL to navigate to on interaction
    var spotifyURLString: String? {get}
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

    var byString: String? {
        return "by"
    }

    var artistName: String {
        return album.artist
    }

    var spotifyURLString: String? {
        guard let spotifyID = album.spotifyID else {
            return nil
        }
        return String.createSpotifyAlbumURLString(albumID: spotifyID)
    }
}

final class LatestEventPlaylistViewModelImplementation: AlbumArtViewModelImplementation, LatestEventAlbumViewModel {
    private let playlist: Playlist

    init(imageLoader: ImageLoader, playlist: Playlist) {
        self.playlist = playlist

        super.init(imageLoader: imageLoader, images: playlist.images)
    }

    var albumType: String {
        return "PLAYLIST"
    }

    var albumName: String {
        return ""
    }

    var byString: String? {
        return nil
    }

    var artistName: String {
        return ""
    }

    var spotifyURLString: String? {
        guard let playlistID = playlist.spotifyID else {
            return nil
        }
        return String.createSpotifyPlaylistURLString(playlistID: playlistID)
    }
}
