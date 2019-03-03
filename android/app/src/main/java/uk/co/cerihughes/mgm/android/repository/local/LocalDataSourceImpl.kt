package uk.co.cerihughes.mgm.android.repository.local

import android.content.Context
import android.preference.PreferenceManager
import uk.co.cerihughes.mgm.android.R

class LocalDataSourceImpl(context: Context): LocalDataSource {

    companion object {
        val PREFERENCES_KEY = "MGM_REMOTE_DATA"
    }

    private val fallbackData: String
    private val sharedPreferences = PreferenceManager.getDefaultSharedPreferences(context)

    init {
        fallbackData = context.resources.openRawResource(R.raw.mgm).bufferedReader().use { it.readText() }
    }

    override fun getLocalData(): String {
        return sharedPreferences.getString(PREFERENCES_KEY, fallbackData)
    }

    override fun persistRemoteData(remoteData: String): Boolean {
        val editor = sharedPreferences.edit()
        editor.putString(PREFERENCES_KEY, remoteData)
        return  editor.commit()
    }
}