package uk.co.cerihughes.mgm.model;

import com.google.gson.annotations.SerializedName;

public enum AlbumType {
    @SerializedName("classic")
    CLASSIC,
    @SerializedName("new")
    NEW
}