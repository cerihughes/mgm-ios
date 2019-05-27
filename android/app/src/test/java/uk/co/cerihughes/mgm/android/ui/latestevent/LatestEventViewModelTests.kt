package uk.co.cerihughes.mgm.android.ui.latestevent

import org.junit.After
import org.junit.Assert
import org.junit.Before
import org.junit.Test
import org.koin.standalone.StandAloneContext.startKoin
import org.koin.standalone.StandAloneContext.stopKoin
import org.koin.standalone.inject
import org.koin.test.KoinTest
import org.koin.test.declareMock
import uk.co.cerihughes.mgm.android.di.appModule
import uk.co.cerihughes.mgm.android.model.createEvent
import uk.co.cerihughes.mgm.android.repository.Repository

class LatestEventViewModelTests: KoinTest {
    val viewModel: LatestEventViewModel by inject()

    @Before
    fun setUp() {
        startKoin(listOf(appModule))
        declareMock<Repository>()
    }

    @After
    fun tearDown() {
        stopKoin()
    }

    @Test
    fun entitiesAndLocation() {
        val event = createEvent(1, 8.0f, 7.0f, locationName = "Location")
        viewModel.setEvents(listOf(event))

        Assert.assertEquals(5, viewModel.numberOfItems())
        Assert.assertEquals(2, viewModel.numberOfEntites())

        Assert.assertEquals("LOCATION", viewModel.headerTitle(0))
        Assert.assertEquals(Pair(0.0, 0.0), viewModel.mapReference())
        Assert.assertEquals("LISTENING TO", viewModel.headerTitle(2))
        Assert.assertNotNull(viewModel.eventEntityViewModel(3))
        Assert.assertNotNull(viewModel.eventEntityViewModel(4))
    }

    @Test
    fun entitiesNoLocation() {
        val event = createEvent(1, 8.0f, 7.0f)
        viewModel.setEvents(listOf(event))

        Assert.assertEquals(3, viewModel.numberOfItems())
        Assert.assertEquals(2, viewModel.numberOfEntites())

        Assert.assertEquals("LISTENING TO", viewModel.headerTitle(0))
        Assert.assertNotNull(viewModel.eventEntityViewModel(1))
        Assert.assertNotNull(viewModel.eventEntityViewModel(2))
    }
}