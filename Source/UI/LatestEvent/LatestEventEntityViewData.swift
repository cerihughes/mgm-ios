import UIKit

protocol LatestEventEntityViewData: AlbumArtViewData {
    /// The album type / playlist
    var entityType: String { get }

    /// The album / playlist name
    var entityName: String { get }

    /// The artist name / playlist owner
    var entityOwner: String { get }

    /// The spotify URL to navigate to on interaction
    var spotifyURL: URL? { get }
}

struct LatestEventEntityViewDataImplementation: LatestEventEntityViewData {
    let loadingImage = (-1).loadingImage
    let images: [Image]?
    let entityType: String
    let entityName: String
    let entityOwner: String
    let spotifyURL: URL?

    init(album: Album) {
        images = album.images
        entityType = album.type == .classic ? "CLASSIC ALBUM" : album.type == .new ? "NEW ALBUM" : "ALBUM"
        entityName = album.name
        entityOwner = album.artist
        spotifyURL = .createSpotifyAlbumURL(albumID: album.spotifyId)
    }

    init(playlist: Playlist) {
        images = playlist.images
        entityType = "PLAYLIST"
        entityName = playlist.name
        entityOwner = playlist.owner
        spotifyURL = .createSpotifyPlaylistURL(playlistID: playlist.spotifyId)
    }
}
