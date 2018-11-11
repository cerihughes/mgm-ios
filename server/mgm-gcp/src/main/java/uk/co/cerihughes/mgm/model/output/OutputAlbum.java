package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

import java.util.List;
import java.util.Optional;

public final class OutputAlbum {
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

    private OutputAlbum(String spotifyId, String name, String artist) {
        super();

        this.spotifyId = spotifyId;
        this.name = name;
        this.artist = artist;
    }

    public static final class Builder {
        private String spotifyId;
        private String name;
        private String artist;
        private Float score;
        private List<OutputImage> images;

        public Builder(String spotifyId, String name, String artist) {
            super();

            this.spotifyId = spotifyId;
            this.name = name;
            this.artist = artist;
        }

        public Builder setScore(Optional<Float> optionalScore) {
            optionalScore.ifPresent(value -> score = value);
            return this;
        }

        public Builder setImages(Optional<List<OutputImage>> optionalImages) {
            optionalImages.ifPresent(value -> images = value);
            return this;
        }

        public Optional<OutputAlbum> build() {
            if (spotifyId == null || name == null || artist == null) {
                return Optional.empty();
            }
            final OutputAlbum album = new OutputAlbum(spotifyId, name, artist);
            album.score = score;
            album.images = images;
            return Optional.of(album);
        }
    }
}
