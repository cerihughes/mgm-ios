package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

import java.util.List;
import java.util.Optional;

public final class OutputPlaylist {
    @SerializedName("spotifyId")
    private String spotifyId;
    @SerializedName("name")
    private String name;
    @SerializedName("owner")
    private String owner;
    @SerializedName("images")
    private List<OutputImage> images;

    private OutputPlaylist(String spotifyId, String name, String owner) {
        super();

        this.spotifyId = spotifyId;
        this.name = name;
        this.owner = owner;
    }

    public static final class Builder {
        private String spotifyId;
        private String name;
        private String owner;
        private List<OutputImage> images;

        public Builder(String spotifyId, String name, String owner) {
            super();

            this.spotifyId = spotifyId;
            this.name = name;
            this.owner = owner;
        }

        public Builder setImages(Optional<List<OutputImage>> optionalImages) {
            optionalImages.ifPresent(value -> images = value);
            return this;
        }

        public Optional<OutputPlaylist> build() {
            if (spotifyId == null || name == null || owner == null) {
                return Optional.empty();
            }
            final OutputPlaylist playlist = new OutputPlaylist(spotifyId, name, owner);
            playlist.images = images;
            return Optional.of(playlist);
        }
    }
}
