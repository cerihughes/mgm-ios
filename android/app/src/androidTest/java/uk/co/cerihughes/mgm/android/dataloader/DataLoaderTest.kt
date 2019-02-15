package uk.co.cerihughes.mgm.android.dataloader

import android.support.test.InstrumentationRegistry
import org.junit.Assert.*
import org.junit.Before
import org.junit.Test

class DataLoaderTest {

    private lateinit var dataLoader: DataLoader

    @Before
    fun setUp() {
        val context = InstrumentationRegistry.getTargetContext()
        dataLoader = DataLoader(context)
    }

    @Test
    fun testDataLoader() {
        val events = dataLoader.getEvents()
        assertEquals(60, events.size)

        var event = events.first()
        assertEquals(2, event.number)
        assertEquals("Songs In The Key Of Life", event.classicAlbum!!.name)
        assertEquals("Ventriloquizzing", event.newAlbum!!.name)
        assertNull(event.playlist)
    }
}