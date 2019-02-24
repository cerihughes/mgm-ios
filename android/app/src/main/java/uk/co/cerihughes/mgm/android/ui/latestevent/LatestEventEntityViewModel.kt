package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.model.Album
import uk.co.cerihughes.mgm.android.model.AlbumType
import uk.co.cerihughes.mgm.android.model.Image
import uk.co.cerihughes.mgm.android.model.Playlist
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModel
import uk.co.cerihughes.mgm.android.ui.SpotifyURLGenerator

class LatestEventEntityViewModel(images: List<Image>, val entityType: String, val entityName: String, val entityOwner: String, val spotifyURL: String?) : AlbumArtViewModel(images) {

    companion object {
        fun createEntityViewModel(album: Album): LatestEventEntityViewModel {
            val entityType = when (album.type) {
                AlbumType.CLASSIC -> "CLASSIC ALBUM"
                AlbumType.NEW -> "NEW ALBUM"
                else -> "ALBUM"
            }

            val spotifyURL = album.spotifyId?.let {
                SpotifyURLGenerator.createSpotifyAlbumURL(it)
            }

            return LatestEventEntityViewModel(album.images, entityType, album.name, album.artist, spotifyURL)
        }

        fun createEntityViewModel(playlist: Playlist): LatestEventEntityViewModel {
            val spotifyURL = playlist.spotifyId?.let {
                SpotifyURLGenerator.createSpotifyPlaylistURL(it)
            }

            return LatestEventEntityViewModel(playlist.images, "PLAYLIST", playlist.name, playlist.owner, spotifyURL)
        }
    }
}