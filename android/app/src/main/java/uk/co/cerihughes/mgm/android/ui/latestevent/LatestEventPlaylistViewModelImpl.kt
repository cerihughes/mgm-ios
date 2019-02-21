package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.model.Playlist
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModelImpl

class LatestEventPlaylistViewModelImpl(playlist: Playlist) : AlbumArtViewModelImpl(playlist.images), LatestEventEntityViewModel {
    override val entityType: String
    override val entityName: String
    override val entityOwner: String

    init {
        entityType = "PLAYLIST"
        entityName = playlist.name
        entityOwner = playlist.owner
    }
}
