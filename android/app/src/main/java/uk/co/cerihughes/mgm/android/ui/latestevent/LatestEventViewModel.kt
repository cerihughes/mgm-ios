package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.dataloader.DataLoader
import uk.co.cerihughes.mgm.android.model.Event
import java.text.DateFormat

class LatestEventViewModel(val dataLoader: DataLoader) {
    companion object {
        private val dateFormatter = DateFormat.getDateInstance(DateFormat.LONG)
    }

    enum class ItemType(val rawValue: Int) {
        LOCATION(0),
        ENTITY(1)
    }

    private var event: Event? = null
    private var eventEntityViewModels: List<LatestEventEntityViewModel> = emptyList()

    fun loadData() {
        // Remove events without albums, then apply descending sort by ID
        val events = dataLoader.getEvents()
        val sortedEvents = events.filter { it.classicAlbum != null && it.newAlbum != null }.sortedByDescending { it.number }

        if (sortedEvents.size == 0) {
            return
        }

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

    fun itemType(position: Int): ItemType {
        return when (position) {
            0 -> if (isLocationAvailable()) ItemType.LOCATION else ItemType.ENTITY
            else -> ItemType.ENTITY
        }
    }

    fun numberOfItems(): Int {
        var locationCount = if (isLocationAvailable()) 1 else 0
        return locationCount + numberOfEntites()
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

    fun headerTitle(section: Int): String? {
        when (section) {
            0 -> return "LOCATION"
            1 -> return "LISTENING TO"
            else -> return null
        }
    }

    fun eventEntityViewModel(index: Int): LatestEventEntityViewModel? {
        val entityIndex = if(isLocationAvailable()) index - 1 else index
        try {
            return eventEntityViewModels[entityIndex]
        } catch (e: IndexOutOfBoundsException) {
            return null
        }
    }
}