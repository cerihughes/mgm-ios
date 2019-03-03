package uk.co.cerihughes.mgm.android.repository.remote

interface RemoteDataSource {

    interface GetRemoteDataCallback {
        fun onDataLoaded(data: String)
        fun onDataNotAvailable()
    }

    fun getRemoteData(callback: GetRemoteDataCallback)
}