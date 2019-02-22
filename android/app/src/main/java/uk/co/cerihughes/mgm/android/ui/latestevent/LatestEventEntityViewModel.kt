package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModel

interface LatestEventEntityViewModel: AlbumArtViewModel {
    fun entityType(): String
    fun entityName(): String
    fun entityOwner(): String
    fun spotifyURL(): String?
}