package uk.co.cerihughes.mgm.model.interim;

import org.junit.jupiter.api.Test;
import uk.co.cerihughes.mgm.model.AlbumType;

import static org.junit.jupiter.api.Assertions.*;

class InterimAlbumTest {
    private static final AlbumType ALBUM_TYPE = AlbumType.CLASSIC;
    private static final String ALBUM_DATA = "ALBUM DATA";
    private static final Float ALBUM_SCORE = new Float(5.6);
    private static final String GOOD_SCORE_STRING = "4.2";
    private static final String BAD_SCORE_STRING = "NOT A FLOAT";

    @Test
    void builderWithGoodData() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData(ALBUM_DATA)
                .setScore(ALBUM_SCORE)
                .build();

        assertNotNull(album);
        assertEquals(ALBUM_TYPE, album.getType());
        assertEquals(ALBUM_DATA, album.getAlbumData());
        assertEquals(ALBUM_SCORE, album.getScore());
    }

    @Test
    void builderWithGoodScoreString() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData(ALBUM_DATA)
                .setScore(GOOD_SCORE_STRING)
                .build();

        assertNotNull(album);
        assertEquals(ALBUM_TYPE, album.getType());
        assertEquals(ALBUM_DATA, album.getAlbumData());
        assertEquals(new Float(4.2), album.getScore());
    }

    @Test
    void builderWithBadScoreString() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData(ALBUM_DATA)
                .setScore(BAD_SCORE_STRING)
                .build();

        assertNotNull(album);
        assertEquals(ALBUM_TYPE, album.getType());
        assertEquals(ALBUM_DATA, album.getAlbumData());
        assertNull(album.getScore());
    }

    @Test
    void builderWithoutScore() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData(ALBUM_DATA)
                .build();

        assertNotNull(album);
        assertEquals(ALBUM_TYPE, album.getType());
        assertEquals(ALBUM_DATA, album.getAlbumData());
        assertNull(album.getScore());
    }

    @Test
    void builderWithNullScoreFloat() {
        final Float f = null;
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData(ALBUM_DATA)
                .setScore(f)
                .build();

        assertNotNull(album);
        assertEquals(ALBUM_TYPE, album.getType());
        assertEquals(ALBUM_DATA, album.getAlbumData());
        assertNull(album.getScore());
    }

    @Test
    void builderWithNullScoreString() {
        final String s = null;
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData(ALBUM_DATA)
                .setScore(s)
                .build();

        assertNotNull(album);
        assertEquals(ALBUM_TYPE, album.getType());
        assertEquals(ALBUM_DATA, album.getAlbumData());
        assertNull(album.getScore());
    }

    @Test
    void builderWithoutType() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setAlbumData(ALBUM_DATA)
                .setScore(ALBUM_SCORE)
                .build();

        assertNull(album);
    }

    @Test
    void builderWithNullType() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(null)
                .setAlbumData(ALBUM_DATA)
                .setScore(ALBUM_SCORE)
                .build();

        assertNull(album);
    }

    @Test
    void builderWithoutData() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setScore(ALBUM_SCORE)
                .build();

        assertNull(album);
    }

    @Test
    void builderWithNullData() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData(null)
                .setScore(ALBUM_SCORE)
                .build();

        assertNull(album);
    }

    @Test
    void builderWithEmptyData() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData("")
                .setScore(ALBUM_SCORE)
                .build();

        assertNull(album);
    }

    @Test
    void builderWithWhitespaceData() {
        final InterimAlbum album = new InterimAlbum.Builder()
                .setType(ALBUM_TYPE)
                .setAlbumData("  ")
                .setScore(ALBUM_SCORE)
                .build();

        assertNull(album);
    }
}