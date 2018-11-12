package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;
import uk.co.cerihughes.mgm.model.AlbumType;

import java.util.List;

public final class OutputAlbum {
    @SerializedName("type")
    private AlbumType type;
    @SerializedName("spotifyId")
    private String spotifyId;
    @SerializedName("name")
    private String name;
    @SerializedName("artist")
    private String artist;
    @SerializedName("score")
    private Float score;
    @SerializedName("images")
    private List<OutputImage> images;

    private OutputAlbum() {
        super();
    }

    public static final class Builder {
        private AlbumType type;
        private String spotifyId;
        private String name;
        private String artist;
        private Float score;
        private List<OutputImage> images;

        public Builder setType(AlbumType type) {
            this.type = type;
            return this;
        }

        public Builder setSpotifyId(String spotifyId) {
            this.spotifyId = spotifyId;
            return this;
        }

        public Builder setName(String name) {
            this.name = name;
            return this;
        }

        public Builder setArtist(String artist) {
            this.artist = artist;
            return this;
        }

        public Builder setScore(Float score) {
            this.score = score;
            return this;
        }

        public Builder setImages(List<OutputImage> images) {
            this.images = images;
            return this;
        }

        public OutputAlbum build() {
            if (type == null || name == null || artist == null) {
                return null;
            }
            final OutputAlbum album = new OutputAlbum();
            album.type = type;
            album.name = name;
            album.artist = artist;
            album.spotifyId = spotifyId;
            album.score = score;
            album.images = images;
            return album;
        }
    }
}
