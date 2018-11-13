package uk.co.cerihughes.mgm.model.interim;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class InterimPlaylistTest {
    private static final String PLAYLILST_DATA = "PLAYLIST DATA";

    @Test
    void builderWithGoodData() {
        final InterimPlaylist playlist = new InterimPlaylist.Builder()
                .setPlaylistData(PLAYLILST_DATA)
                .build();

        assertNotNull(playlist);
        assertEquals(PLAYLILST_DATA, playlist.getPlaylistData());
    }

    @Test
    void builderWithoutData() {
        final InterimPlaylist playlist = new InterimPlaylist.Builder()
                .build();

        assertNull(playlist);
    }

    @Test
    void builderWithNullData() {
        final InterimPlaylist playlist = new InterimPlaylist.Builder()
                .setPlaylistData(null)
                .build();

        assertNull(playlist);
    }

    @Test
    void builderWithEmptyData() {
        final InterimPlaylist playlist = new InterimPlaylist.Builder()
                .setPlaylistData("")
                .build();

        assertNull(playlist);
    }

    @Test
    void builderWithWhitespaceData() {
        final InterimPlaylist playlist = new InterimPlaylist.Builder()
                .setPlaylistData(" \n \n \n")
                .build();

        assertNull(playlist);
    }
}