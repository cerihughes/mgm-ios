import Foundation

extension String {
    static func createSpotifyAlbumURLString(albumID: String?) -> String? {
        guard let albumID = albumID else {
            return nil
        }
        return "spotify:album:\(albumID)"
    }

    static func createSpotifyPlaylistURLString(playlistID: String?) -> String? {
        guard let playlistID = playlistID else {
            return nil
        }
        return "spotify:playlist:\(playlistID)"
    }
}
