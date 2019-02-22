package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.ui.SpotifyAwareViewModel

interface LatestEventViewModel: SpotifyAwareViewModel {
    enum class ItemType(val rawValue: Int) {
        LOCATION(0),
        ENTITY(1)
    }

    fun title(): String

    fun locationName(): String?

    fun mapReference(): Pair<Double, Double>?

    fun itemType(position: Int): ItemType

    fun numberOfItems(): Int

    fun numberOfEntites(): Int

    fun isLocationAvailable(): Boolean

    fun headerTitle(section: Int): String?

    fun eventEntityViewModel(index: Int): LatestEventEntityViewModel?
}