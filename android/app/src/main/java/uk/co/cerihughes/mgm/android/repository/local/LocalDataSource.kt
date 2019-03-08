package uk.co.cerihughes.mgm.android.repository.local

interface LocalDataSource {
    fun getLocalData(): String?
    fun persistRemoteData(remoteData: String): Boolean
}