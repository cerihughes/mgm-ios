package uk.co.cerihughes.mgm.android.dataloader

import uk.co.cerihughes.mgm.android.model.Event

class SerialEventLoader(private val eventLoaders: List<EventLoader>): EventLoader {

    override fun getEvents(): List<Event>? {
        for (eventLoader in eventLoaders) {
            eventLoader.getEvents()?.let {
                return it
            }
        }
        return null
    }
}