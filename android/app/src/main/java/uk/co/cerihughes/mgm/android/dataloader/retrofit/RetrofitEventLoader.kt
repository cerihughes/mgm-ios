package uk.co.cerihughes.mgm.android.dataloader.retrofit

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import uk.co.cerihughes.mgm.android.dataloader.EventLoader
import uk.co.cerihughes.mgm.android.dataloader.GsonFactory
import uk.co.cerihughes.mgm.android.model.Event
import java.io.IOException

class RetrofitEventLoader: EventLoader {

    private val gson = GsonFactory.createGson()

    override fun getEvents(): List<Event>? {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://mgm-gcp.appspot.com")
            .addConverterFactory(GsonConverterFactory.create(gson))
            .build()

        val service = retrofit.create<RetrofitEventService>(RetrofitEventService::class.java)
        val call = service.getRemoteEvents()
        try {
            val response = call.execute()
            return response.body()
        } catch (e: IOException) {
            return null
        }
    }
}