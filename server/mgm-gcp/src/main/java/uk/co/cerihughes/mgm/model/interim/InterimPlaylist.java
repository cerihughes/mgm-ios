package uk.co.cerihughes.mgm.model.interim;

import java.util.Optional;

public final class InterimPlaylist {
    private String playlistData;

    private InterimPlaylist(String playlistData) {
        super();

        this.playlistData = playlistData;
    }

    public String getPlaylistData() {
        return playlistData;
    }

    public static final class Builder {
        private String playlistData;

        public Builder(String playlistData) {
            super();

            this.playlistData = playlistData;
        }

        public Optional<InterimPlaylist> build() {
            if (playlistData == null) {
                return Optional.empty();
            }
            return Optional.of(new InterimPlaylist(playlistData));
        }
    }
}