package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.model.Album
import uk.co.cerihughes.mgm.android.model.AlbumType
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModelImpl
import uk.co.cerihughes.mgm.android.ui.SpotifyURLGenerator

class LatestEventAlbumViewModelImpl(private val album: Album) : AlbumArtViewModelImpl(album.images), LatestEventEntityViewModel {
    override fun entityType(): String {
        return when (album.type) {
            AlbumType.CLASSIC -> "CLASSIC ALBUM"
            AlbumType.NEW -> "NEW ALBUM"
            else -> "ALBUM"
        }
    }

    override fun entityName(): String {
        return album.name
    }

    override fun entityOwner(): String {
        return album.artist
    }

    override fun spotifyURL(): String? {
        val albumId = album.spotifyID ?: return null
        return SpotifyURLGenerator.createSpotifyAlbumURL(albumId)
    }
}