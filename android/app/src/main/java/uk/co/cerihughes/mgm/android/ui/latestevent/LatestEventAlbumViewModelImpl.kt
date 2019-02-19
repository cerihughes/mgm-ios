package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.model.Album
import uk.co.cerihughes.mgm.android.model.AlbumType
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModelImpl

class LatestEventAlbumViewModelImpl(album: Album) : AlbumArtViewModelImpl(album.images), LatestEventEntityViewModel {
    override val entityType: String
    override val entityName: String
    override val entityOwner: String

    init {
        entityType = if (album.type == AlbumType.CLASSIC) "CLASSIC ALBUM" else if (album.type == AlbumType.NEW) "NEW ALBUM" else "ALBUM"
        entityName = album.name
        entityOwner = album.artist
    }
}