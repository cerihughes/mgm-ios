package uk.co.cerihughes.mgm.android.repository

import uk.co.cerihughes.mgm.android.model.Event

interface Repository {

    interface GetEventsCallback {
        fun onEventsLoaded(data: List<Event>)
    }

    fun getEvents(callback: GetEventsCallback)
}