package uk.co.cerihughes.mgm.android.ui.albumscores

import android.graphics.Color
import android.support.annotation.ColorInt
import android.support.annotation.DrawableRes
import uk.co.cerihughes.mgm.android.R

enum class AlbumAward(@DrawableRes val drawable: Int, @ColorInt val colour: Int) {
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