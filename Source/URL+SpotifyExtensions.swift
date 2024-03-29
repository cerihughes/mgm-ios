import Foundation

extension URL {
    static func createSpotifyAlbumURL(albumID: String?) -> URL? {
        guard let albumID else { return nil }
        return URL(string: "spotify:album:\(albumID)")
    }

    static func createSpotifyPlaylistURL(playlistID: String?) -> URL? {
        guard let playlistID else { return nil }
        return URL(string: "spotify:playlist:\(playlistID)")
    }
}
