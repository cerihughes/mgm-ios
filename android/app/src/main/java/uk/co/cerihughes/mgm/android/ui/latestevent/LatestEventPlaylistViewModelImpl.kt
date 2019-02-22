package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.model.Playlist
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModelImpl
import uk.co.cerihughes.mgm.android.ui.SpotifyURLGenerator

class LatestEventPlaylistViewModelImpl(private val playlist: Playlist) : AlbumArtViewModelImpl(playlist.images), LatestEventEntityViewModel {
    override fun entityType(): String {
        return "PLAYLIST"
    }

    override fun entityName(): String {
        return playlist.name
    }

    override fun entityOwner(): String {
        return playlist.owner
    }

    override fun spotifyURL(): String? {
        val playlistId = playlist.spotifyId ?: return null
        return SpotifyURLGenerator.createSpotifyPlaylistURL(playlistId)
    }
}
