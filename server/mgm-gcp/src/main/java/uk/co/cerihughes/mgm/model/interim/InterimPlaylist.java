package uk.co.cerihughes.mgm.model.interim;

import java.util.Optional;

public final class InterimPlaylist {
    private String spotifyId;

    private InterimPlaylist(String spotifyId) {
        super();

        this.spotifyId = spotifyId;
    }

    public String getSpotifyId() {
        return spotifyId;
    }

    public static final class Builder {
        private String spotifyId;

        public Builder(String spotifyId) {
            super();

            this.spotifyId = spotifyId;
        }

        public Optional<InterimPlaylist> build() {
            if (spotifyId == null) {
                return Optional.empty();
            }
            return Optional.of(new InterimPlaylist(spotifyId));
        }
    }
}