package uk.co.cerihughes.mgm.model.interim;

import org.junit.jupiter.api.Test;
import uk.co.cerihughes.mgm.model.AlbumType;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

public class InterimEventTest {
    private static final Integer NUMBER = 2;
    private static final String GOOD_NUMBER_STRING = "3";
    private static final String BAD_NUMBER_STRING = "EIGHT";

    private static final LocalDate DATE = LocalDate.of(2018, 11, 13);
    private static final String GOOD_DATE_STRING = "13/11/2018";
    private static final String BAD_DATE_STRING = "2018-11-13";

    private static final InterimAlbum ALBUM = new InterimAlbum.Builder()
            .setType(AlbumType.CLASSIC)
            .setAlbumData("DATA")
            .build();

    private static final InterimPlaylist PLAYLIST = new InterimPlaylist.Builder()
            .setPlaylistData("DATA")
            .build();

    @Test
    void builderWithGoodData() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(DATE)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNotNull(event);
        assertEquals(NUMBER.intValue(), event.getNumber());
        assertEquals(DATE, event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertEquals(PLAYLIST, event.getPlaylist());
    }

    @Test
    void builderWithGoodNumberString() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(GOOD_NUMBER_STRING)
                .setDate(DATE)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNotNull(event);
        assertEquals(3, event.getNumber());
        assertEquals(DATE, event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertEquals(PLAYLIST, event.getPlaylist());
    }

    @Test
    void builderWithBadNumberString() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(BAD_NUMBER_STRING)
                .setDate(DATE)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNull(event);
    }

    @Test
    void builderWithoutNumber() {
        final InterimEvent event = new InterimEvent.Builder()
                .setDate(DATE)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNull(event);
    }

    @Test
    void builderWithNullNumberInteger() {
        final Integer i = null;
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(i)
                .setDate(DATE)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNull(event);
    }

    @Test
    void builderWithNullNumberString() {
        final String s = null;
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(s)
                .setDate(DATE)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNull(event);
    }

    @Test
    void builderWithGoodDateString() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(GOOD_DATE_STRING)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNotNull(event);
        assertEquals(NUMBER.intValue(), event.getNumber());
        assertEquals(DATE, event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertEquals(PLAYLIST, event.getPlaylist());
    }

    @Test
    void builderWithBadDateString() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(BAD_DATE_STRING)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNotNull(event);
        assertEquals(NUMBER.intValue(), event.getNumber());
        assertNull(event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertEquals(PLAYLIST, event.getPlaylist());
    }

    @Test
    void builderWithoutDate() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNotNull(event);
        assertEquals(NUMBER.intValue(), event.getNumber());
        assertNull(event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertEquals(PLAYLIST, event.getPlaylist());
    }

    @Test
    void builderWithNullDate() {
        final LocalDate d = null;
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(d)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNotNull(event);
        assertEquals(NUMBER.intValue(), event.getNumber());
        assertNull(event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertEquals(PLAYLIST, event.getPlaylist());
    }

    @Test
    void builderWithNullDateString() {
        final String s = null;
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(s)
                .setClassicAlbum(ALBUM)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNotNull(event);
        assertEquals(NUMBER.intValue(), event.getNumber());
        assertNull(event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertEquals(PLAYLIST, event.getPlaylist());
    }

    @Test
    void builderWithoutClassicAlbum() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(DATE)
                .setNewAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNull(event);
    }

    @Test
    void builderWithoutNewAlbum() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(DATE)
                .setClassicAlbum(ALBUM)
                .setPlaylist(PLAYLIST)
                .build();

        assertNull(event);
    }

    @Test
    void builderWithoutPlaylist() {
        final InterimEvent event = new InterimEvent.Builder()
                .setNumber(NUMBER)
                .setDate(DATE)
                .setNewAlbum(ALBUM)
                .setClassicAlbum(ALBUM)
                .build();

        assertNotNull(event);
        assertEquals(NUMBER.intValue(), event.getNumber());
        assertEquals(DATE, event.getDate());
        assertEquals(ALBUM, event.getClassicAlbum());
        assertEquals(ALBUM, event.getNewAlbum());
        assertNull(event.getPlaylist());
    }
}