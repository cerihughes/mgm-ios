package uk.co.cerihughes.mgm.android.ui

import android.arch.lifecycle.ViewModel
import android.os.Handler
import android.os.Looper
import uk.co.cerihughes.mgm.android.model.Event
import uk.co.cerihughes.mgm.android.repository.RemoteDataSource

open abstract class RemoteDataLoadingViewModel(private val remoteDataSource: RemoteDataSource): ViewModel() {

    private val backgroundThreadHandler = Handler()
    private val mainThreadHandler = Handler(Looper.getMainLooper())

    interface LoadDataCallback {
        fun onDataLoaded()
    }

    fun loadData(callback: LoadDataCallback) {
        backgroundThreadHandler.post {
            remoteDataSource.getEvents(object: RemoteDataSource.GetEventsCallback {
                override fun onEventsLoaded(data: List<Event>) {
                    mainThreadHandler.post {
                        setEvents(data)
                        callback.onDataLoaded()
                    }
                }

                override fun onDataNotAvailable() {
                    mainThreadHandler.post {
                        setEvents(emptyList())
                        callback.onDataLoaded()
                    }
                }
            })
        }
    }

    abstract fun setEvents(events: List<Event>)
}