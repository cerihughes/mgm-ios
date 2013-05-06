package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import junit.framework.Assert;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Playlist;

public class TestLastFmPlaylistsJsonConverter
{
	private static final String NO_RESULTS_JSON = "{\"playlists\":{\"#text\":\"\\n\",\"user\":\"hughesceritest\"}}";
	private static final String SINGLE_RESULT_JSON = "{\"playlists\":{\"playlist\":{\"id\":\"11130446\",\"title\":\"Untitled\",\"description\":\"Playlist 1\\n\",\"date\":\"2013-03-29T12:08:41\",\"size\":\"1\",\"duration\":\"388\",\"streamable\":\"0\",\"creator\":\"http:\\/\\/www.last.fm\\/user\\/hughesceri\",\"url\":\"http:\\/\\/www.last.fm\\/user\\/hughesceri\\/library\\/playlists\\/6mkb2_\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/88164707.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/88164707.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/88164707.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/88164707.jpg\",\"size\":\"extralarge\"}]},\"@attr\":{\"user\":\"hughesceri\"}}}";
	private static final String MULTIPLE_RESULTS_JSON = "{\"playlists\":{\"playlist\":[{\"id\":\"2614993\",\"title\":\"Doglist\",\"description\":\"Guess what i searched for..\",\"date\":\"2008-05-22T09:24:23\",\"size\":\"18\",\"duration\":\"3970\",\"streamable\":\"0\",\"creator\":\"http:\\/\\/www.last.fm\\/user\\/RJ\",\"url\":\"http:\\/\\/www.last.fm\\/user\\/RJ\\/library\\/playlists\\/1k1qp_doglist\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/5976386.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/5976386.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/5976386.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/5976386.jpg\",\"size\":\"extralarge\"}]},{\"id\":\"2615079\",\"title\":\"Duck playlist\",\"description\":\"Duck and cover\",\"date\":\"2008-05-22T09:40:09\",\"size\":\"10\",\"duration\":\"2357\",\"streamable\":\"0\",\"creator\":\"http:\\/\\/www.last.fm\\/user\\/RJ\",\"url\":\"http:\\/\\/www.last.fm\\/user\\/RJ\\/library\\/playlists\\/1k1t3_duck_playlist\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/5985590.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/5985590.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/5985590.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/5985590.jpg\",\"size\":\"extralarge\"}]},{\"id\":\"2612216\",\"title\":\"Sexyplaylist\",\"description\":\"My only regret is that the search feature doesn't give me more than 10 results\",\"date\":\"2008-05-21T19:43:46\",\"size\":\"9\",\"duration\":\"2464\",\"streamable\":\"0\",\"creator\":\"http:\\/\\/www.last.fm\\/user\\/RJ\",\"url\":\"http:\\/\\/www.last.fm\\/user\\/RJ\\/library\\/playlists\\/1jzlk_sexyplaylist\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/5976429.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/5976429.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/5976429.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/5976429.jpg\",\"size\":\"extralarge\"}]},{\"id\":\"5606\",\"title\":\"Misc gubbins\",\"description\":\"This is a misc test playlist with a few random tracks in it.\",\"date\":\"2006-11-15T13:05:48\",\"size\":\"10\",\"duration\":\"2775\",\"streamable\":\"0\",\"creator\":\"http:\\/\\/www.last.fm\\/user\\/RJ\",\"url\":\"http:\\/\\/www.last.fm\\/user\\/RJ\\/library\\/playlists\\/4bq_misc_gubbins\",\"image\":[{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/34\\/4218758.jpg\",\"size\":\"small\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/64\\/4218758.jpg\",\"size\":\"medium\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/126\\/4218758.jpg\",\"size\":\"large\"},{\"#text\":\"http:\\/\\/userserve-ak.last.fm\\/serve\\/252\\/4218758.jpg\",\"size\":\"extralarge\"}]}],\"@attr\":{\"user\":\"RJ\"}}}";

	private LastFmPlaylistsJsonConverter cut;
	private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	@Before
	public void setUp()
	{
		cut = new LastFmPlaylistsJsonConverter();
	}

	private String getDateString(Date date)
	{
		if (date != null)
		{
			return sdf.format(date);
		}
		return null;
	}

	@Test
	public void testNoResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(NO_RESULTS_JSON);
		final List<Playlist> result = cut.convert(json);
		Assert.assertEquals(0, result.size());
	}

	@Test
	public void testSingleResult() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(SINGLE_RESULT_JSON);
		final List<Playlist> result = cut.convert(json);
		Assert.assertEquals(1, result.size());
		final Playlist playlist = result.get(0);
		Assert.assertEquals(EDaoType.LAST_FM_DIRECT, playlist.getSource());
		Assert.assertEquals("Untitled", playlist.getName());
		Assert.assertEquals("Playlist 1\n", playlist.getDescription());
		Assert.assertNull(playlist.getPopularity());
		Assert.assertEquals("2013-03-29T12:08:41", getDateString(playlist.getCreationDate()));
		Assert.assertEquals((Integer) 1, playlist.getTrackCount());
		Assert.assertEquals("http://www.last.fm/user/hughesceri/library/playlists/6mkb2_", playlist.getUri());
		Assert.assertEquals("11130446", playlist.getId());
		Assert.assertEquals("http://userserve-ak.last.fm/serve/126/88164707.jpg", playlist.getImageUri());
	}

	@Test
	public void testMultipleResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(MULTIPLE_RESULTS_JSON);
		final List<Playlist> result = cut.convert(json);
		Assert.assertEquals(4, result.size());
		final Playlist playlist = result.get(0);
		Assert.assertEquals(EDaoType.LAST_FM_DIRECT, playlist.getSource());
		Assert.assertEquals("Doglist", playlist.getName());
		Assert.assertEquals("Guess what i searched for..", playlist.getDescription());
		Assert.assertNull(playlist.getPopularity());
		Assert.assertEquals("2008-05-22T09:24:23", getDateString(playlist.getCreationDate()));
		Assert.assertEquals((Integer) 18, playlist.getTrackCount());
		Assert.assertEquals("http://www.last.fm/user/RJ/library/playlists/1k1qp_doglist", playlist.getUri());
		Assert.assertEquals("2614993", playlist.getId());
		Assert.assertEquals("http://userserve-ak.last.fm/serve/126/5976386.jpg", playlist.getImageUri());
	}
}
