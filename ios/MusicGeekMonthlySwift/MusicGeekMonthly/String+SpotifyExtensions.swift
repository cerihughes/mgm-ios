import Foundation

extension String {
    static func createSpotifyAlbumURLString(albumID: String) -> String {
        return "spotify:album:\(albumID)"
    }

    static func createSpotifyPlaylistURLString(playlistID: String) -> String {
        return "spotify:playlist:\(playlistID)"
    }
}
