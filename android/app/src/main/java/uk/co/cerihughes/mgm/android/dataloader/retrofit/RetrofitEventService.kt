package uk.co.cerihughes.mgm.android.dataloader.retrofit

import retrofit2.Call
import retrofit2.http.GET
import uk.co.cerihughes.mgm.android.model.Event

interface RetrofitEventService {
    @GET("mgm.json")
    fun getRemoteEvents(): Call<List<Event>>
}