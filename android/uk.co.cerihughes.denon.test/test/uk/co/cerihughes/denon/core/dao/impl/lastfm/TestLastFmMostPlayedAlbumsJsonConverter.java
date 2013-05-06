package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.List;

import junit.framework.Assert;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;

public class TestLastFmMostPlayedAlbumsJsonConverter
{
	private static final String NO_RESULTS_JSON = "{\"topalbums\":{\"#text\":\"\\n    \",\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"0\",\"perPage\":\"50\",\"totalPages\":\"0\",\"total\":\"0\"}}";
	private static final String SINGLE_RESULT_JSON = "{\"topalbums\":{\"album\":{\"name\":\"OK Computer\",\"playcount\":\"1\",\"mbid\":\"0b6b4ba0-d36f-47bd-b4ea-6a5b91842d29\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\\/OK+Computer\",\"artist\":{\"name\":\"Radiohead\",\"mbid\":\"a74b1b7f-71a5-4011-9441-d0b5e4122711\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\"},\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34s\\/66781226.png\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64s\\/66781226.png\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/66781226.png\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/300x300\\/66781226.png\",\"size\":\"extralarge\"}],\"@attr\":{\"rank\":\"1\"}},\"@attr\":{\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"1\",\"perPage\":\"50\",\"totalPages\":\"1\",\"total\":\"1\"}}}";
	private static final String MULTIPLE_RESULTS_JSON = "{\"topalbums\":{\"album\":[{\"name\":\"OK Computer\",\"playcount\":\"1\",\"mbid\":\"0b6b4ba0-d36f-47bd-b4ea-6a5b91842d29\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\\/OK+Computer\",\"artist\":{\"name\":\"Radiohead\",\"mbid\":\"a74b1b7f-71a5-4011-9441-d0b5e4122711\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\"},\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34s\\/66781226.png\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64s\\/66781226.png\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/66781226.png\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/300x300\\/66781226.png\",\"size\":\"extralarge\"}],\"@attr\":{\"rank\":\"1\"}},{\"name\":\"Blur\",\"playcount\":\"1\",\"mbid\":\"c3789a0c-dccc-4d64-b692-943f305708e1\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Blur\\/Blur\",\"artist\":{\"name\":\"Blur\",\"mbid\":\"ba853904-ae25-4ebb-89d6-c44cfbd71bd2\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Blur\"},\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34s\\/68206062.png\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64s\\/68206062.png\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/68206062.png\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/300x300\\/68206062.png\",\"size\":\"extralarge\"}],\"@attr\":{\"rank\":\"2\"}}],\"@attr\":{\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"1\",\"perPage\":\"50\",\"totalPages\":\"1\",\"total\":\"2\"}}}";

	private LastFmMostPlayedAlbumsJsonConverter cut;

	@Before
	public void setUp()
	{
		cut = new LastFmMostPlayedAlbumsJsonConverter();
	}

	@Test
	public void testNoResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(NO_RESULTS_JSON);
		final List<Album> result = cut.convert(json);
		Assert.assertEquals(0, result.size());
	}

	@Test
	public void testSingleResult() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(SINGLE_RESULT_JSON);
		final List<Album> result = cut.convert(json);
		Assert.assertEquals(1, result.size());
		final Album album = result.get(0);
		Assert.assertEquals(EDaoType.LAST_FM_DIRECT, album.getSource());
		Assert.assertEquals("OK Computer", album.getName());
		Assert.assertNull(album.getPopularity());
		Assert.assertEquals("http://www.last.fm/music/Radiohead/OK+Computer", album.getUri());
		Assert.assertEquals("0b6b4ba0-d36f-47bd-b4ea-6a5b91842d29", album.getId());
		Assert.assertEquals("Radiohead", album.getArtistName());		
		Assert.assertEquals("http://userserve-ak.last.fm/serve/126/66781226.png", album.getImageUri());
		Assert.assertEquals("a74b1b7f-71a5-4011-9441-d0b5e4122711", album.getAttribute(LastFmJsonConverter.LAST_FM_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("0b6b4ba0-d36f-47bd-b4ea-6a5b91842d29", album.getAttribute(LastFmJsonConverter.LAST_FM_ALBUM_ID_ATTRIBUTE));
	}

	@Test
	public void testMultipleResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(MULTIPLE_RESULTS_JSON);
		final List<Album> result = cut.convert(json);
		Assert.assertEquals(2, result.size());
		final Album album = result.get(1);
		Assert.assertEquals(EDaoType.LAST_FM_DIRECT, album.getSource());
		Assert.assertEquals("Blur", album.getName());
		Assert.assertNull(album.getPopularity());
		Assert.assertEquals("http://www.last.fm/music/Blur/Blur", album.getUri());
		Assert.assertEquals("c3789a0c-dccc-4d64-b692-943f305708e1", album.getId());
		Assert.assertEquals("Blur", album.getArtistName());		
		Assert.assertEquals("http://userserve-ak.last.fm/serve/126/68206062.png", album.getImageUri());
		Assert.assertEquals("ba853904-ae25-4ebb-89d6-c44cfbd71bd2", album.getAttribute(LastFmJsonConverter.LAST_FM_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("c3789a0c-dccc-4d64-b692-943f305708e1", album.getAttribute(LastFmJsonConverter.LAST_FM_ALBUM_ID_ATTRIBUTE));
	}
}
