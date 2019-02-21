package uk.co.cerihughes.mgm.android.ui.albumscores

import android.support.annotation.ColorInt
import android.support.annotation.DrawableRes
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModel

interface AlbumScoreViewModel : AlbumArtViewModel {
    fun albumName(): String

    fun artistName(): String

    fun rating(): String

    @ColorInt
    fun ratingColour(): Int

    @DrawableRes
    fun awardImage(): Int

    fun position(): String
}