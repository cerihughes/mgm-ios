package uk.co.cerihughes.mgm.android.ui

import android.support.annotation.DrawableRes
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.model.Image

open class AlbumArtViewModelImpl(private val images: List<Image>) : AlbumArtViewModel {

    @DrawableRes
    override fun placeholderImage(): Int {
        return R.drawable.album1
    }

    override fun coverArtURL(largestDimension: Int): String? {
        return image(largestDimension)
    }

    private fun image(largestDimension: Int): String? {
        var candidate: String? = null
        for (image in images) {
            val size = image.size ?: 0
            if (size > largestDimension) {
                candidate = image.url
            } else {
                return candidate ?: image.url
            }
        }
        return candidate
    }
}