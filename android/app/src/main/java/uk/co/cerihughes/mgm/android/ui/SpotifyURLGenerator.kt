package uk.co.cerihughes.mgm.android.ui

class SpotifyURLGenerator {
    companion object {
        fun createSpotifyAlbumURL(albumID: String): String {
            return "spotify:album:$albumID"
        }

        fun createSpotifyPlaylistURL(playlistID: String): String {
            return "spotify:playlist:$playlistID"
        }
    }
}