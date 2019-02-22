package uk.co.cerihughes.mgm.android.ui

import android.content.Context
import android.content.pm.PackageManager

open class SpotifyAwareViewModelImpl: SpotifyAwareViewModel {
    override fun isSpotifyInstalled(context: Context): Boolean {
        val pm = context.packageManager
        try {
            pm.getPackageInfo("com.spotify.music", 0)
            return true
        } catch (e: PackageManager.NameNotFoundException) {
            return false
        }
    }
}