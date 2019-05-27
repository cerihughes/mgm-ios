package uk.co.cerihughes.mgm.android.repository.local

import android.support.test.InstrumentationRegistry
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNull
import org.junit.Before
import org.junit.Test
import uk.co.cerihughes.mgm.android.model.Event
import uk.co.cerihughes.mgm.android.repository.GsonFactory
import uk.co.cerihughes.mgm.android.repository.local.LocalDataSourceImpl

class LocalDataSourceImplTest {

    private lateinit var localDataSource: LocalDataSourceImpl

    @Before
    fun setUp() {
        val context = InstrumentationRegistry.getTargetContext()
        localDataSource = LocalDataSourceImpl(context)
    }

    @Test
    fun testDataLoader() {
        val localData = localDataSource.getLocalData()!!
        val events = GsonFactory.createGson().fromJson(localData , Array<Event>::class.java).toList()
        assertEquals(60, events.size)

        var event = events.first()
        assertEquals(2, event.number)
        assertEquals("Songs In The Key Of Life", event.classicAlbum!!.name)
        assertEquals("Ventriloquizzing", event.newAlbum!!.name)
        assertNull(event.playlist)
    }
}