package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModel

interface LatestEventEntityViewModel: AlbumArtViewModel {
    val entityType: String
    val entityName: String
    val entityOwner: String
}