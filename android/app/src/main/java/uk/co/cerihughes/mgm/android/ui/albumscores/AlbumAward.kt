package uk.co.cerihughes.mgm.android.ui.albumscores

import android.support.annotation.DrawableRes
import uk.co.cerihughes.mgm.android.R

enum class AlbumAward(@DrawableRes val drawable: Int) {
    GOLD(R.drawable.award_gold),
    SILVER(R.drawable.award_silver),
    BRONZE(R.drawable.award_plate),
    NONE(R.drawable.award_none);

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

    @DrawableRes
    fun awardImage(): Int {
        return drawable
    }
}