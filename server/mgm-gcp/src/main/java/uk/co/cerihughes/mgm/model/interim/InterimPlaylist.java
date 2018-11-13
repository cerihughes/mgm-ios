package uk.co.cerihughes.mgm.model.interim;

public final class InterimPlaylist {
    private String playlistData;

    private InterimPlaylist() {
        super();
    }

    public String getPlaylistData() {
        return playlistData;
    }

    public static final class Builder {
        private String playlistData;

        public Builder setPlaylistData(String playlistData) {
            this.playlistData = playlistData;
            return this;
        }

        public InterimPlaylist build() {
            if (playlistData == null || playlistData.trim().length() == 0) {
                return null;
            }
            final InterimPlaylist playlist = new InterimPlaylist();
            playlist.playlistData = playlistData;
            return playlist;
        }
    }
}