package uk.co.cerihughes.mgm.android.ui

import android.content.Context

interface SpotifyAwareViewModel {
    fun isSpotifyInstalled(context: Context): Boolean
}