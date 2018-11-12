package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

public final class GoogleSheetsAlbum {
    @SerializedName("name")
    private String name;
    @SerializedName("artist")
    private String artist;
    @SerializedName("images")
    private List<GoogleSheetsImage> images;

    public String getName() {
        return name;
    }

    public String getArtist() {
        return artist;
    }

    public List<GoogleSheetsImage> getImages() {
        return Optional.ofNullable(images).orElse(Collections.emptyList());
    }
}