package uk.co.cerihughes.mgm.android.ui

import android.support.annotation.DrawableRes

interface AlbumArtViewModel {
    @DrawableRes fun placeholderImage(): Int
    fun coverArtURL(largestDimension: Int): String?
}