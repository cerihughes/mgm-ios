package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.model.Event
import uk.co.cerihughes.mgm.android.repository.Repository
import uk.co.cerihughes.mgm.android.ui.RemoteDataLoadingViewModel
import java.text.DateFormat

class LatestEventViewModel(repository: Repository): RemoteDataLoadingViewModel(repository) {

    companion object {
        private val dateFormatter = DateFormat.getDateInstance(DateFormat.LONG)
    }

    enum class ItemType(val rawValue: Int) {
        TITLE(0),
        LOCATION(1),
        ENTITY(2)
    }

    private var event: Event? = null
    private var eventEntityViewModels: List<LatestEventEntityViewModel> = emptyList()

    fun isLoaded(): Boolean = event != null

    override fun setEvents(events: List<Event>) {
        // Remove events without albums, then apply descending sort by ID
        val sortedEvents = events.filter { it.classicAlbum != null && it.newAlbum != null }.sortedByDescending { it.number }

        if (sortedEvents.size > 0) {
            var entityViewModels: MutableList<LatestEventEntityViewModel> = mutableListOf()
            var event = sortedEvents.first()

            event.classicAlbum?.let {
                entityViewModels.add(LatestEventEntityViewModel.createEntityViewModel(it))
            }
            event.newAlbum?.let {
                entityViewModels.add(LatestEventEntityViewModel.createEntityViewModel(it))
            }
            event.playlist?.let {
                entityViewModels.add(LatestEventEntityViewModel.createEntityViewModel(it))
            }

            this.event = event
            this.eventEntityViewModels = entityViewModels
        }
    }

    fun title(): String {
        val date = event?.date ?: return "Next Event"

        val dateString = dateFormatter.format(date)
        return "Next Event: $dateString"
    }

    fun locationName(): String? {
        val location = event?.location ?: return null

        return location.name
    }

    fun mapReference(): Pair<Double, Double>? {
        val location = event?.location ?: return null

        return Pair(location.latitude, location.longitude)
    }

    fun numberOfItems(): Int {
        var locationCount = if (isLocationAvailable()) 2 else 0
        return locationCount + numberOfEntites() + 1
    }

    fun numberOfEntites(): Int {
        return eventEntityViewModels.size
    }

    fun isLocationAvailable(): Boolean {
        event?.location?.let {
            return true
        }
        return false
    }

    fun itemType(position: Int): ItemType {
        if (isLocationAvailable()) {
            return when (position) {
                0, 2 -> ItemType.TITLE
                1 -> ItemType.LOCATION
                else -> ItemType.ENTITY
            }
        }
        return when (position) {
            0 -> ItemType.TITLE
            else -> ItemType.ENTITY
        }
    }

    fun headerTitle(position: Int): String? {
        return when (position) {
            0 -> if (isLocationAvailable()) "LOCATION" else "LISTENING TO"
            else -> "LISTENING TO"
        }
    }

    fun eventEntityViewModel(position: Int): LatestEventEntityViewModel? {
        val entityIndex = if(isLocationAvailable()) position - 3 else position - 1
        try {
            return eventEntityViewModels[entityIndex]
        } catch (e: IndexOutOfBoundsException) {
            return null
        }
    }
}