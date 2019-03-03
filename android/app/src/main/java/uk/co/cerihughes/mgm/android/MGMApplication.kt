package uk.co.cerihughes.mgm.android

import android.app.Application
import org.koin.android.ext.android.startKoin
import uk.co.cerihughes.mgm.android.di.appModule

class MGMApplication: Application() {

    override fun onCreate() {
        super.onCreate()

        startKoin(this, listOf(appModule))
    }
}