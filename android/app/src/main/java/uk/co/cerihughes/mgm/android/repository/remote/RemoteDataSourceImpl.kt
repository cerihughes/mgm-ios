package uk.co.cerihughes.mgm.android.repository.remote

import okhttp3.ResponseBody
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit

class RemoteDataSourceImpl: RemoteDataSource {

    override fun getRemoteData(callback: RemoteDataSource.GetRemoteDataCallback) {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://mgm-gcp.appspot.com")
            .build()

        val service = retrofit.create<RetrofitEventService>(RetrofitEventService::class.java)
        service.getRemoteEvents().enqueue(object : Callback<ResponseBody> {
            override fun onResponse(call: Call<ResponseBody>, response: Response<ResponseBody>) {
                response.body()?.string()?.let {
                    callback.onDataLoaded(it)
                } ?: callback.onDataNotAvailable()
            }

            override fun onFailure(call: Call<ResponseBody>, t: Throwable) {
                callback.onDataNotAvailable()
            }
        })
    }
}