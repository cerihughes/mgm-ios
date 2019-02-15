package uk.co.cerihughes.mgm.android.dataloader

import android.content.Context
import com.google.gson.GsonBuilder
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.model.Event

class DataLoader(private val context: Context): GCPService {
    private val gson = GsonBuilder().setDateFormat("dd/MM/yyyy").create()

    override fun getEvents(): List<Event> {
        val movieFileContents = context.resources.openRawResource(R.raw.mgm).bufferedReader().use { it.readText() }
        return gson.fromJson(movieFileContents , Array<Event>::class.java).toList()
    }
}