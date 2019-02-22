package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.model.Event
import uk.co.cerihughes.mgm.android.ui.SpotifyAwareViewModelImpl
import java.text.DateFormat

class LatestEventViewModelImpl(events: List<Event>): SpotifyAwareViewModelImpl(), LatestEventViewModel {
    companion object {
        private val dateFormatter = DateFormat.getDateInstance(DateFormat.LONG)
    }

    private var event: Event? = null
    private var eventEntityViewModels: List<LatestEventEntityViewModel> = emptyList()

    init {
        // Remove events without albums, then apply descending sort by ID
        val sortedEvents = events.filter { it.classicAlbum != null && it.newAlbum != null }.sortedByDescending { it.number }

        if (sortedEvents.size > 0) {
            var entityViewModels: MutableList<LatestEventEntityViewModel> = mutableListOf()
            var event = sortedEvents.first()

            event.classicAlbum?.let {
                entityViewModels.add(LatestEventAlbumViewModelImpl(it))
            }
            event.newAlbum?.let {
                entityViewModels.add(LatestEventAlbumViewModelImpl(it))
            }
            event.playlist?.let {
                entityViewModels.add(LatestEventPlaylistViewModelImpl(it))
            }

            this.event = event
            this.eventEntityViewModels = entityViewModels
        }
    }

    override fun title(): String {
        val date = event?.date ?: return "Next Event"

        val dateString = dateFormatter.format(date)
        return "Next Event: $dateString"
    }

    override fun locationName(): String? {
        val location = event?.location ?: return null

        return location.name
    }

    override fun mapReference(): Pair<Double, Double>? {
        val location = event?.location ?: return null

        return Pair(location.latitude, location.longitude)
    }

    override fun itemType(position: Int): LatestEventViewModel.ItemType {
        return when (position) {
            0 -> if (isLocationAvailable()) LatestEventViewModel.ItemType.LOCATION else LatestEventViewModel.ItemType.ENTITY
            else -> LatestEventViewModel.ItemType.ENTITY
        }
    }

    override fun numberOfItems(): Int {
        var locationCount = if (isLocationAvailable()) 1 else 0
        return locationCount + numberOfEntites()
    }

    override fun numberOfEntites(): Int {
        return eventEntityViewModels.size
    }

    override fun isLocationAvailable(): Boolean {
        event?.location?.let {
            return true
        }
        return false
    }

    override fun headerTitle(section: Int): String? {
        when (section) {
            0 -> return "LOCATION"
            1 -> return "LISTENING TO"
            else -> return null
        }
    }

    override fun eventEntityViewModel(index: Int): LatestEventEntityViewModel? {
        val entityIndex = if(isLocationAvailable()) index - 1 else index
        try {
            return eventEntityViewModels[entityIndex]
        } catch (e: IndexOutOfBoundsException) {
            return null
        }
    }

}