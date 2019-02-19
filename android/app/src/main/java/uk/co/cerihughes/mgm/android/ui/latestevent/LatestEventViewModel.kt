package uk.co.cerihughes.mgm.android.ui.latestevent

import uk.co.cerihughes.mgm.android.dataloader.DataLoader
import uk.co.cerihughes.mgm.android.model.Event
import java.text.DateFormat

class LatestEventViewModel(val dataLoader: DataLoader) {
    companion object {
        private val dateFormatter = DateFormat.getDateInstance(DateFormat.LONG)
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

    fun numberOfEntites(): Int {
        return eventEntityViewModels.size
    }

    fun numberOfLocations(): Int {
        event?.location?.let {
            return 1
        }
        return 0
    }

    fun headerTitle(section: Int): String? {
        when (section) {
            0 -> return "LOCATION"
            1 -> return "LISTENING TO"
            else -> return null
        }
    }

    fun eventEntityViewModel(index: Int): LatestEventEntityViewModel? {
        try {
            return eventEntityViewModels[index]
        } catch (e: IndexOutOfBoundsException) {
            return null
        }
    }
}