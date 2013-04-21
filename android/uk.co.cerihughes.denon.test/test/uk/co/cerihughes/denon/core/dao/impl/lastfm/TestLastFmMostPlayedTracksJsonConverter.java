package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.List;

import junit.framework.Assert;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Track;

public class TestLastFmMostPlayedTracksJsonConverter
{
	private static final String NO_RESULTS_JSON = "{\"toptracks\":{\"#text\":\"\\n    \",\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"0\",\"perPage\":\"50\",\"totalPages\":\"0\",\"total\":\"0\"}}";
	private static final String SINGLE_RESULT_JSON = "{\"toptracks\":{\"track\":{\"name\":\"Let Down\",\"duration\":\"300\",\"playcount\":\"1\",\"mbid\":\"47b02a82-c3bf-4647-b894-dd1c8f608e7f\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\\/_\\/Let+Down\",\"streamable\":{\"#text\":\"1\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Radiohead\",\"mbid\":\"a74b1b7f-71a5-4011-9441-d0b5e4122711\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\"},\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34s\\/66781226.png\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64s\\/66781226.png\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/66781226.png\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/300x300\\/66781226.png\",\"size\":\"extralarge\"}],\"@attr\":{\"rank\":\"1\"}},\"@attr\":{\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"1\",\"perPage\":\"50\",\"totalPages\":\"1\",\"total\":\"1\"}}}";
	private static final String MULTIPLE_RESULTS_JSON = "{\"toptracks\":{\"track\":[{\"name\":\"Let Down\",\"duration\":\"300\",\"playcount\":\"1\",\"mbid\":\"47b02a82-c3bf-4647-b894-dd1c8f608e7f\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\\/_\\/Let+Down\",\"streamable\":{\"#text\":\"1\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Radiohead\",\"mbid\":\"a74b1b7f-71a5-4011-9441-d0b5e4122711\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Radiohead\"},\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34s\\/66781226.png\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64s\\/66781226.png\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/66781226.png\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/300x300\\/66781226.png\",\"size\":\"extralarge\"}],\"@attr\":{\"rank\":\"1\"}},{\"name\":\"Song 2\",\"duration\":\"121\",\"playcount\":\"1\",\"mbid\":\"12135772-1725-4971-9890-78d363abaf9e\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Blur\\/_\\/Song+2\",\"streamable\":{\"#text\":\"1\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Blur\",\"mbid\":\"ba853904-ae25-4ebb-89d6-c44cfbd71bd2\",\"url\":\"http:\\/\\/www.last.fm\\/music\\/Blur\"},\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34s\\/68206062.png\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64s\\/68206062.png\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/68206062.png\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/300x300\\/68206062.png\",\"size\":\"extralarge\"}],\"@attr\":{\"rank\":\"2\"}}],\"@attr\":{\"user\":\"hughesceritest\",\"type\":\"overall\",\"page\":\"1\",\"perPage\":\"50\",\"totalPages\":\"1\",\"total\":\"2\"}}}";

	private LastFmMostPlayedTracksJsonConverter cut;

	@Before
	public void setUp()
	{
		cut = new LastFmMostPlayedTracksJsonConverter();
	}

	@Test
	public void testNoResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(NO_RESULTS_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(0, result.size());
	}

	@Test
	public void testSingleResult() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(SINGLE_RESULT_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(1, result.size());
		final Track track = result.get(0);
		Assert.assertEquals(EDaoType.LAST_FM_DIRECT, track.getSource());
		Assert.assertEquals("Let Down", track.getName());
		Assert.assertNull(track.getPopularity());
		Assert.assertNull(track.getTrackNumber());
		Assert.assertEquals((Integer) 300, track.getLength());
		Assert.assertEquals("http://www.last.fm/music/Radiohead/_/Let+Down", track.getLocation());
		Assert.assertEquals("47b02a82-c3bf-4647-b894-dd1c8f608e7f", track.getId());
		Assert.assertEquals("Radiohead", track.getArtistName());
		Assert.assertEquals("http://userserve-ak.last.fm/serve/126/66781226.png", track.getImageUri());
		Assert.assertNull(track.getAlbumName());
		Assert.assertEquals("a74b1b7f-71a5-4011-9441-d0b5e4122711", track.getAttribute(LastFmJsonConverter.LAST_FM_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("47b02a82-c3bf-4647-b894-dd1c8f608e7f", track.getAttribute(LastFmJsonConverter.LAST_FM_TRACK_ID_ATTRIBUTE));
	}

	@Test
	public void testMultipleResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(MULTIPLE_RESULTS_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(2, result.size());
		final Track track = result.get(1);
		Assert.assertEquals(EDaoType.LAST_FM_DIRECT, track.getSource());
		Assert.assertEquals("Song 2", track.getName());
		Assert.assertNull(track.getPopularity());
		Assert.assertNull(track.getTrackNumber());
		Assert.assertEquals((Integer) 121, track.getLength());
		Assert.assertEquals("http://www.last.fm/music/Blur/_/Song+2", track.getLocation());
		Assert.assertEquals("12135772-1725-4971-9890-78d363abaf9e", track.getId());
		Assert.assertEquals("Blur", track.getArtistName());
		Assert.assertEquals("http://userserve-ak.last.fm/serve/126/68206062.png", track.getImageUri());
		Assert.assertNull(track.getAlbumName());
		Assert.assertEquals("ba853904-ae25-4ebb-89d6-c44cfbd71bd2", track.getAttribute(LastFmJsonConverter.LAST_FM_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("12135772-1725-4971-9890-78d363abaf9e", track.getAttribute(LastFmJsonConverter.LAST_FM_TRACK_ID_ATTRIBUTE));
	}
}
