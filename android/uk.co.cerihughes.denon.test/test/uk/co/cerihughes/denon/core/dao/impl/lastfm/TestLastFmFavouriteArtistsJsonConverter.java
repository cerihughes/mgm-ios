package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.List;

import junit.framework.Assert;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Artist;

public class TestLastFmFavouriteArtistsJsonConverter
{
	private static final String NO_RESULTS_JSON = "{\"topartists\":{\"#text\":\"\\n    \",\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"0\",\"perPage\":\"50\",\"totalPages\":\"0\",\"total\":\"0\"}}";
	private static final String SINGLE_RESULT_JSON = "{\"topartists\":{\"artist\":{\"name\":\"Radiohead\",\"playcount\":\"1\",\"mbid\":\"a74b1b7f-71a5-4011-9441-d0b5e4122711\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\",\"streamable\":\"1\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/5801617.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/5801617.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/5801617.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/5801617.jpg\",\"size\":\"extralarge\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/500\\/5801617\\/Radiohead+by+Kevin+Westenberg.jpg\",\"size\":\"mega\"}],\"@attr\":{\"rank\":\"1\"}},\"@attr\":{\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"1\",\"perPage\":\"50\",\"totalPages\":\"1\",\"total\":\"1\"}}}";
	private static final String MULTIPLE_RESULTS_JSON = "{\"topartists\":{\"artist\":[{\"name\":\"Blur\",\"playcount\":\"1\",\"mbid\":\"ba853904-ae25-4ebb-89d6-c44cfbd71bd2\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Blur\",\"streamable\":\"1\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/35509015.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/35509015.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/35509015.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/35509015.jpg\",\"size\":\"extralarge\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/_\\/35509015\\/Blur.jpg\",\"size\":\"mega\"}],\"@attr\":{\"rank\":\"1\"}},{\"name\":\"Radiohead\",\"playcount\":\"1\",\"mbid\":\"a74b1b7f-71a5-4011-9441-d0b5e4122711\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\",\"streamable\":\"1\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/5801617.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/5801617.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/5801617.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/5801617.jpg\",\"size\":\"extralarge\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/500\\/5801617\\/Radiohead+by+Kevin+Westenberg.jpg\",\"size\":\"mega\"}],\"@attr\":{\"rank\":\"2\"}}],\"@attr\":{\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"1\",\"perPage\":\"50\",\"totalPages\":\"1\",\"total\":\"2\"}}}";

	private LastFmFavouriteArtistsJsonConverter cut;

	@Before
	public void setUp()
	{
		cut = new LastFmFavouriteArtistsJsonConverter();
	}

	@Test
	public void testNoResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(NO_RESULTS_JSON);
		final List<Artist> result = cut.convert(json);
		Assert.assertEquals(0, result.size());
	}

	@Test
	public void testSingleResult() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(SINGLE_RESULT_JSON);
		final List<Artist> result = cut.convert(json);
		Assert.assertEquals(1, result.size());
		final Artist artist = result.get(0);
		Assert.assertEquals(EDaoType.SPOTIFY_DIRECT, artist.getSource());
		Assert.assertEquals("Joanna Gruesome", artist.getName());
		Assert.assertEquals(0.00244f, artist.getPopularity());
		Assert.assertEquals("spotify:artist:6K2bPQMt5xXBCfMdU5Lokj", artist.getLocation());
		Assert.assertEquals("6K2bPQMt5xXBCfMdU5Lokj", artist.getId());
		Assert.assertNull(artist.getAlbumCount());
	}

	@Test
	public void testMultipleResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(MULTIPLE_RESULTS_JSON);
		final List<Artist> result = cut.convert(json);
		Assert.assertEquals(42, result.size());
		final Artist artist = result.get(0);
		Assert.assertEquals(EDaoType.SPOTIFY_DIRECT, artist.getSource());
		Assert.assertEquals("Bj\u00f6rk", artist.getName());
		Assert.assertEquals(0.61962f, artist.getPopularity());
		Assert.assertEquals("spotify:artist:7w29UYBi0qsHi5RTcv3lmA", artist.getLocation());
		Assert.assertEquals("7w29UYBi0qsHi5RTcv3lmA", artist.getId());
		Assert.assertNull(artist.getAlbumCount());
	}

}
