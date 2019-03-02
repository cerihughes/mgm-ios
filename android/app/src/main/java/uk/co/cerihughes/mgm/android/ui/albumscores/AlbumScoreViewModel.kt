package uk.co.cerihughes.mgm.android.ui.albumscores

import android.graphics.Color
import android.support.annotation.ColorInt
import android.support.annotation.DrawableRes
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.model.Album
import uk.co.cerihughes.mgm.android.ui.AlbumArtViewModel
import uk.co.cerihughes.mgm.android.ui.SpotifyURLGenerator

class AlbumScoreViewModel(private val album: Album, private val index: Int, private val position: String) : AlbumArtViewModel(album.images) {

    private enum class AlbumAward(@DrawableRes val drawable: Int, @ColorInt val colour: Int) {
        GOLD(R.drawable.award_gold, Color.argb(255, 238, 187, 100)),
        SILVER(R.drawable.award_silver, Color.argb(255, 180, 180, 185)),
        BRONZE(R.drawable.award_plate, Color.argb(255, 217, 162, 129)),
        NONE(R.drawable.award_none, Color.argb(255, 55, 106, 77));

        companion object {
            fun createAward(score: Float): AlbumAward {
                if (score > 8.5) {
                    return GOLD
                }
                if (score > 7.0) {
                    return SILVER
                }
                if (score > 5.5) {
                    return BRONZE
                }
                return NONE
            }
        }
    }

    private val award: AlbumAward

    init {
        award = AlbumAward.createAward(album.score ?: 0.0f)
    }

    fun albumName(): String {
        return album.name
    }

    fun artistName(): String {
        return album.artist
    }

    fun rating(): String {
        val score = album.score ?: return ""
        return String.format("%.01f", score)
    }

    @ColorInt
    fun ratingColour(): Int {
        return award.colour
    }

    @DrawableRes
    fun awardImage(): Int {
        return award.drawable
    }

    fun position(): String {
        return position
    }

    fun spotifyURL(): String? {
        val albumId = album.spotifyId ?: return null
        return SpotifyURLGenerator.createSpotifyAlbumURL(albumId)
    }
}