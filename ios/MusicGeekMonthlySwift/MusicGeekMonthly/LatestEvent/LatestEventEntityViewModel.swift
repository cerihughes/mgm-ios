import UIKit

protocol LatestEventEntityViewModel: AlbumArtViewModel {
    /// The album type / playlist
    var entityType: String {get}

    /// The album / playlist name
    var entityName: String {get}

    /// The artist name / playlist owner
    var entityOwner: String {get}

    /// The spotify URL to navigate to on interaction
    var spotifyURLString: String? {get}
}

final class LatestEventEntityViewModelImplementation: AlbumArtViewModelImplementation, LatestEventEntityViewModel {
    let entityType: String
    let entityName: String
    let entityOwner: String
    let spotifyURLString: String?

    init(imageLoader: ImageLoader, album: Album) {
        self.entityType = album.type == .classic ? "CLASSIC ALBUM" : "NEW ALBUM"
        self.entityName = album.name
        self.entityOwner = album.artist
        self.spotifyURLString = String.createSpotifyAlbumURLString(albumID: album.spotifyID)

        super.init(imageLoader: imageLoader, images: album.images)
    }

    init(imageLoader: ImageLoader, playlist: Playlist) {
        self.entityType = "PLAYLIST"
        self.entityName = playlist.name
        self.entityOwner = playlist.owner
        self.spotifyURLString = String.createSpotifyPlaylistURLString(playlistID: playlist.spotifyID)

        super.init(imageLoader: imageLoader, images: playlist.images)
    }
}
