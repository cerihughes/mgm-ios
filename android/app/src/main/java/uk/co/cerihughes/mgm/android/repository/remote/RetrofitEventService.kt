package uk.co.cerihughes.mgm.android.repository.remote

import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.http.GET

interface RetrofitEventService {
    @GET("mgm.json")
    fun getRemoteEvents(): Call<ResponseBody>
}