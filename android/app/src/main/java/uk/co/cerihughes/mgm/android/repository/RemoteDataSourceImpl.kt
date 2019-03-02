package uk.co.cerihughes.mgm.android.repository

import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import uk.co.cerihughes.mgm.android.model.Event

class RemoteDataSourceImpl: RemoteDataSource {

    private val gson = GsonFactory.createGson()

    private var cachedEvents: List<Event>? = null

    override fun getEvents(callback: RemoteDataSource.GetEventsCallback) {
        cachedEvents?.let {
            callback.onEventsLoaded(it)
        } ?: loadEvents(callback)
    }

    private fun loadEvents(callback: RemoteDataSource.GetEventsCallback) {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://mgm-gcp.appspot.com")
            .addConverterFactory(GsonConverterFactory.create(gson))
            .build()

        val service = retrofit.create<RetrofitEventService>(RetrofitEventService::class.java)
        service.getRemoteEvents().enqueue(object : Callback<List<Event>> {
            override fun onResponse(call: Call<List<Event>>, response: Response<List<Event>>) {
                response.body()?.let {
                    cachedEvents = it
                    callback.onEventsLoaded(it)
                } ?: callback.onDataNotAvailable()
            }

            override fun onFailure(call: Call<List<Event>>, t: Throwable) {
                callback.onDataNotAvailable()
            }
        })
    }
}