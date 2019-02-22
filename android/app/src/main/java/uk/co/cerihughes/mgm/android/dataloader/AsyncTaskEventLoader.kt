package uk.co.cerihughes.mgm.android.dataloader

import android.content.Context
import android.support.v4.content.AsyncTaskLoader
import uk.co.cerihughes.mgm.android.dataloader.fallback.FallbackEventLoader
import uk.co.cerihughes.mgm.android.dataloader.retrofit.RetrofitEventLoader
import uk.co.cerihughes.mgm.android.model.Event

class AsyncTaskEventLoader(context: Context): AsyncTaskLoader<List<Event>>(context) {

    companion object {
        val EVENT_LOADER_ID = 422726
    }

    override fun loadInBackground(): List<Event>? {
        val fallbackEventLoader = FallbackEventLoader(context)
        val retrofitEventLoader = RetrofitEventLoader()
        val eventLoaders = listOf(retrofitEventLoader, fallbackEventLoader)
        val serialEventLoader = SerialEventLoader(eventLoaders)
        return serialEventLoader.getEvents()
    }

    override fun onStartLoading() {
        super.onStartLoading()

        forceLoad()
    }
}