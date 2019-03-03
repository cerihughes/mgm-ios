package uk.co.cerihughes.mgm.android

import android.app.Application
import org.koin.android.ext.android.startKoin

class MGMApplication: Application() {

    override fun onCreate() {
        super.onCreate()

        startKoin(this, listOf(appModule))
    }
}