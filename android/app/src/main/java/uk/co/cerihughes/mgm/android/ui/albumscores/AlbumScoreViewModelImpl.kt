package uk.co.cerihughes.mgm.android.ui.albumscores

import android.support.annotation.ColorInt
import android.support.annotation.DrawableRes
import uk.co.cerihughes.mgm.android.model.Album
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModelImpl

class AlbumScoreViewModelImpl(private val album: Album, private val index: Int) : AlbumArtViewModelImpl(album.images), AlbumScoreViewModel {

    private val award: AlbumAward

    init {
        award = AlbumAward.createAward(album.score ?: 0.0f)
    }

    override fun albumName(): String {
        return album.name
    }

    override fun artistName(): String {
        return album.artist
    }

    override fun rating(): String {
        val score = album.score ?: return ""
        return String.format("%.01f", score)
    }

    @ColorInt
    override fun ratingColour(): Int {
        return award.colour
    }

    @DrawableRes
    override fun awardImage(): Int {
        return award.drawable
    }

    override fun position(): String {
        return String.format("%d", index + 1)
    }
}