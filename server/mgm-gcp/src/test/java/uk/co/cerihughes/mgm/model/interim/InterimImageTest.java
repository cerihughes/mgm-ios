package uk.co.cerihughes.mgm.model.interim;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class InterimImageTest {
    private static final Integer SIZE = 64;
    private static final String GOOD_SIZE_STRING = "300";
    private static final String BAD_SIZE_STRING = "5.6";
    private static final String URL_DATA = "URL DATA";

    @Test
    void builderWithGoodData() {
        final InterimImage image = new InterimImage.Builder()
                .setSize(SIZE)
                .setUrl(URL_DATA)
                .build();

        assertNotNull(image);
        assertEquals(SIZE, image.getSize());
        assertEquals(URL_DATA, image.getUrl());
    }

    @Test
    void builderWithGoodSizeString() {
        final InterimImage image = new InterimImage.Builder()
                .setSize(GOOD_SIZE_STRING)
                .setUrl(URL_DATA)
                .build();

        assertNotNull(image);
        assertEquals((Integer) 300, image.getSize());
        assertEquals(URL_DATA, image.getUrl());
    }

    @Test
    void builderWithBadSizeString() {
        final InterimImage image = new InterimImage.Builder()
                .setSize(BAD_SIZE_STRING)
                .setUrl(URL_DATA)
                .build();

        assertNotNull(image);
        assertNull(image.getSize());
        assertEquals(URL_DATA, image.getUrl());
    }

    @Test
    void builderWithoutSize() {
        final InterimImage image = new InterimImage.Builder()
                .setUrl(URL_DATA)
                .build();

        assertNotNull(image);
        assertNull(image.getSize());
        assertEquals(URL_DATA, image.getUrl());
    }

    @Test
    void builderWithNullSizeInteger() {
        final Integer i = null;
        final InterimImage image = new InterimImage.Builder()
                .setSize(i)
                .setUrl(URL_DATA)
                .build();

        assertNotNull(image);
        assertNull(image.getSize());
        assertEquals(URL_DATA, image.getUrl());
    }

    @Test
    void builderWithNullSizeString() {
        final String s = null;
        final InterimImage image = new InterimImage.Builder()
                .setSize(s)
                .setUrl(URL_DATA)
                .build();

        assertNotNull(image);
        assertNull(image.getSize());
        assertEquals(URL_DATA, image.getUrl());
    }

    @Test
    void builderWithoutUrl() {
        final InterimImage image = new InterimImage.Builder()
                .setSize(SIZE)
                .build();

        assertNull(image);
    }

    @Test
    void builderWithNullUrl() {
        final InterimImage image = new InterimImage.Builder()
                .setSize(SIZE)
                .setUrl(null)
                .build();

        assertNull(image);
    }

    @Test
    void builderWithEmptyUrl() {
        final InterimImage image = new InterimImage.Builder()
                .setSize(SIZE)
                .setUrl("")
                .build();

        assertNull(image);
    }

    @Test
    void builderWithWhitespaceUrl() {
        final InterimImage image = new InterimImage.Builder()
                .setSize(SIZE)
                .setUrl("    ")
                .build();

        assertNull(image);
    }
}