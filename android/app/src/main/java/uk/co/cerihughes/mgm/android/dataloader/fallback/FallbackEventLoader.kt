package uk.co.cerihughes.mgm.android.dataloader.fallback

import android.content.Context
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.dataloader.EventLoader
import uk.co.cerihughes.mgm.android.dataloader.GsonFactory
import uk.co.cerihughes.mgm.android.model.Event

class FallbackEventLoader(context: Context): EventLoader {
    private val fallbackData: String
    private val gson = GsonFactory.createGson()

    init {
        fallbackData = context.resources.openRawResource(R.raw.mgm).bufferedReader().use { it.readText() }
    }

    override fun getEvents(): List<Event>? {
        return gson.fromJson(fallbackData , Array<Event>::class.java).toList()
    }
}