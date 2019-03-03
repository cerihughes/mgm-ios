package uk.co.cerihughes.mgm.android.repository

import uk.co.cerihughes.mgm.android.model.Event
import uk.co.cerihughes.mgm.android.repository.local.LocalDataSource
import uk.co.cerihughes.mgm.android.repository.remote.RemoteDataSource

class RepositoryImpl(private val remoteDataSource: RemoteDataSource, private val localDataSource: LocalDataSource): Repository {

    private val gson = GsonFactory.createGson()

    private var cachedEvents: List<Event>? = null

    override fun getEvents(callback: Repository.GetEventsCallback) {
        cachedEvents?.let {
            callback.onEventsLoaded(it)
        } ?: loadEvents(callback)
    }

    private fun loadEvents(callback: Repository.GetEventsCallback) {
        remoteDataSource.getRemoteData(object: RemoteDataSource.GetRemoteDataCallback {
            override fun onDataLoaded(data: String) {
                localDataSource.persistRemoteData(data)
                val events = gson.fromJson(data , Array<Event>::class.java).toList()
                cachedEvents = events
                callback.onEventsLoaded(events)
            }

            override fun onDataNotAvailable() {
                val localData = localDataSource.getLocalData()
                val events = gson.fromJson(localData , Array<Event>::class.java).toList()
                callback.onEventsLoaded(events)
            }
        })
    }
}