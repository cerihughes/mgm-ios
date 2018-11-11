package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

import java.util.List;

public class OutputPlaylist {
    @SerializedName("spotifyId")
    private String spotifyId;
    @SerializedName("name")
    private String name;
    @SerializedName("owner")
    private String owner;
    @SerializedName("images")
    private List<OutputImage> images;

    public String getSpotifyId() {
        return spotifyId;
    }

    public void setSpotifyId(String spotifyId) {
        this.spotifyId = spotifyId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public List<OutputImage> getImages() {
        return images;
    }

    public void setImages(List<OutputImage> images) {
        this.images = images;
    }
}
