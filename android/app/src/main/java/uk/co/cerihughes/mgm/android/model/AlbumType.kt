package uk.co.cerihughes.mgm.android.model

import com.google.gson.annotations.SerializedName

enum class AlbumType {
    @SerializedName("classic")
    CLASSIC,

    @SerializedName("new")
    NEW
}