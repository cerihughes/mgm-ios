package uk.co.cerihughes.mgm.android.repository

import uk.co.cerihughes.mgm.android.model.Event

interface RemoteDataSource {

    interface GetEventsCallback {

        fun onEventsLoaded(tasks: List<Event>)
        fun onDataNotAvailable()
    }

    fun getEvents(callback: GetEventsCallback)
}