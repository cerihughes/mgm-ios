package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.List;

import junit.framework.Assert;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Track;

public class TestSpotifyTracksForAlbumJsonConverter
{
	private static final String SINGLE_RESULT_JSON = "{\"album\": {\"artist-id\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Razor\", \"artist\": \"Foo Fighters\", \"external-ids\": [{\"type\": \"upc\", \"id\": \"828767205656\"}], \"released\": \"2005\", \"tracks\": [{\"available\": true, \"track-number\": \"1\", \"popularity\": \"0.31000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500083\"}], \"length\": 288.299, \"href\": \"spotify:track:07KdWMEZCzLPJYEty0BLS9\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"Razor - Acoustic recorded live on Edge 102.1, Toronto on June 16, 2005\"}], \"href\": \"spotify:album:2LxM25pCWYgto509zZhQ1B\", \"availability\": {\"territories\": \"AD AE AF AG AI AL AM AN AO AQ AR AT AZ BA BB BD BE BF BG BH BI BJ BM BN BO BR BS BT BW BY BZ CA CD CF CG CH CI CK CL CM CN CO CR CU CV CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GH GI GL GM GN GP GQ GR GT GU GW GY HK HN HR HT HU ID IE IL IN IO IQ IR IS IT JM JO KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MZ NA NC NE NG NI NL NO NP NR NU OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TJ TK TL TM TN TO TR TT TV TZ UA UG UY UZ VA VC VE VG VN VU WF WS YE YT ZA ZM ZW ZZ\"}}, \"info\": {\"type\": \"album\"}}";
	private static final String MULTIPLE_RESULTS_JSON = "{\"album\": {\"artist-id\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"In Your Honor\", \"artist\": \"Foo Fighters\", \"external-ids\": [{\"type\": \"upc\", \"id\": \"828767967257\"}], \"released\": \"2005\", \"tracks\": [{\"available\": true, \"track-number\": \"1\", \"popularity\": \"0.44000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500025\"}], \"length\": 230.362, \"href\": \"spotify:track:06LzBUkKZpPAWiEwB6iVri\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"In Your Honor\"}, {\"available\": true, \"track-number\": \"2\", \"popularity\": \"0.47000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500007\"}], \"length\": 196.818, \"href\": \"spotify:track:2MKEQhvPb2VaJXjx5X8Yg6\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"No Way Back\"}, {\"available\": true, \"track-number\": \"3\", \"popularity\": \"0.49000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500001\"}], \"length\": 255.906, \"href\": \"spotify:track:5FZxsHWIvUsmSK1IAvm2pp\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"Best Of You\"}, {\"available\": true, \"track-number\": \"4\", \"popularity\": \"0.51000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500008\"}], \"length\": 252.376, \"href\": \"spotify:track:1QZFn6QUNHfCp8s06C91hw\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"DOA\"}, {\"available\": true, \"track-number\": \"5\", \"popularity\": \"0.42000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500009\"}], \"length\": 117.155, \"href\": \"spotify:track:7xT9J7vWvVEx7AfrNZBcZR\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"Hell\"}, {\"available\": true, \"track-number\": \"6\", \"popularity\": \"0.42000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500010\"}], \"length\": 199.668, \"href\": \"spotify:track:10gtVK2wMCv1HzjhHKnFnw\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"The Last Song\"}, {\"available\": true, \"track-number\": \"7\", \"popularity\": \"0.39000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500011\"}], \"length\": 278.913, \"href\": \"spotify:track:6OuwrRwl7q5VVpPREsx4j7\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"Free Me\"}, {\"available\": true, \"track-number\": \"8\", \"popularity\": \"0.40000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500012\"}], \"length\": 288.953, \"href\": \"spotify:track:6Nt5aSBZC3Rs97mQeNzICw\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"Resolve\"}, {\"available\": true, \"track-number\": \"9\", \"popularity\": \"0.39000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500013\"}], \"length\": 238.598, \"href\": \"spotify:track:7nO47INYJ98touXCXOM1ui\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"The Deepest Blues Are Black\"}, {\"available\": true, \"track-number\": \"10\", \"popularity\": \"0.39000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500014\"}], \"length\": 352.355, \"href\": \"spotify:track:223Iqe4eRgg7ReO6JFCx8P\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"1\", \"name\": \"End Over End\"}, {\"available\": true, \"track-number\": \"1\", \"popularity\": \"0.40000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500015\"}], \"length\": 313.425, \"href\": \"spotify:track:2wvfMTbZDPzpZhOt7z6tVo\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Still\"}, {\"available\": true, \"track-number\": \"2\", \"popularity\": \"0.39000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500016\"}], \"length\": 303.228, \"href\": \"spotify:track:3trcjkAjWu8qK60f4lKkGS\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"What If I Do?\"}, {\"available\": true, \"track-number\": \"3\", \"popularity\": \"0.41000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500017\"}], \"length\": 209.839, \"href\": \"spotify:track:48ktarzxsErc0CbMysLGDw\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Miracle\"}, {\"available\": true, \"track-number\": \"4\", \"popularity\": \"0.39000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500018\"}], \"length\": 266.05, \"href\": \"spotify:track:7IznnRqG5qJihAFZFPOq5l\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Another Round\"}, {\"available\": true, \"track-number\": \"5\", \"popularity\": \"0.39000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500019\"}], \"length\": 193.42, \"href\": \"spotify:track:7cxAyJ1UcrkejC7fTTZcUV\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Friend Of A Friend\"}, {\"available\": true, \"track-number\": \"6\", \"popularity\": \"0.38000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500020\"}], \"length\": 316.51, \"href\": \"spotify:track:1ct1ICmKoBb5zsU4zc53bd\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Over And Out\"}, {\"available\": true, \"track-number\": \"7\", \"popularity\": \"0.39000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500021\"}], \"length\": 272.116, \"href\": \"spotify:track:39kHMfF3dBMZMbOtoit1XF\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"On The Mend\"}, {\"available\": true, \"track-number\": \"8\", \"popularity\": \"0.40000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500022\"}], \"length\": 229.369, \"href\": \"spotify:track:2Ei5auE9kCmwKB2JZtKPKO\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Virginia Moon\"}, {\"available\": true, \"track-number\": \"9\", \"popularity\": \"0.40000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500023\"}], \"length\": 200.871, \"href\": \"spotify:track:02O71P5xudugRmFCFsQe9E\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Cold Day In The Sun\"}, {\"available\": true, \"track-number\": \"10\", \"popularity\": \"0.41000\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USRW30500024\"}], \"length\": 293.502, \"href\": \"spotify:track:3G6xjB96azqSKV3uU44Bmt\", \"artists\": [{\"href\": \"spotify:artist:7jy3rLJdDQY21OgRLCZ9sD\", \"name\": \"Foo Fighters\"}], \"disc-number\": \"2\", \"name\": \"Razor\"}], \"href\": \"spotify:album:2eprpJCYbCbPZRKVGIEJxZ\", \"availability\": {\"territories\": \"AR AT BO BR CA CH CL CR DE GT HN MX NI PA PY SV US UY\"}}, \"info\": {\"type\": \"album\"}}";

	private SpotifyTracksForAlbumJsonConverter cut;

	@Before
	public void setUp()
	{
		cut = new SpotifyTracksForAlbumJsonConverter();
	}

	@Test
	public void testSingleResult() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(SINGLE_RESULT_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(1, result.size());
		final Track track = result.get(0);
		Assert.assertEquals(EDaoType.SPOTIFY_DIRECT, track.getSource());
		Assert.assertEquals("Razor - Acoustic recorded live on Edge 102.1, Toronto on June 16, 2005", track.getName());
		Assert.assertEquals(0.31000f, track.getPopularity());
		Assert.assertEquals("spotify:track:07KdWMEZCzLPJYEty0BLS9", track.getLocation());
		Assert.assertEquals("07KdWMEZCzLPJYEty0BLS9", track.getId());
		Assert.assertEquals((Integer) 1, track.getTrackNumber());
		Assert.assertEquals((Integer) 1, track.getDiscNumber());
		Assert.assertEquals((Integer) 288, track.getLength());
		Assert.assertEquals("Razor", track.getAlbumName());
		Assert.assertEquals("Foo Fighters", track.getArtistName());
		Assert.assertEquals("7jy3rLJdDQY21OgRLCZ9sD", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("2LxM25pCWYgto509zZhQ1B", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ALBUM_ID_ATTRIBUTE));
		Assert.assertEquals("07KdWMEZCzLPJYEty0BLS9", track.getAttribute(SpotifyJsonConverter.SPOTIFY_TRACK_ID_ATTRIBUTE));
	}

	@Test
	public void testMultipleResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(MULTIPLE_RESULTS_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(20, result.size());
		final Track track = result.get(11);
		Assert.assertEquals(EDaoType.SPOTIFY_DIRECT, track.getSource());
		Assert.assertEquals("What If I Do?", track.getName());
		Assert.assertEquals(0.39000f, track.getPopularity());
		Assert.assertEquals("spotify:track:3trcjkAjWu8qK60f4lKkGS", track.getLocation());
		Assert.assertEquals("3trcjkAjWu8qK60f4lKkGS", track.getId());
		Assert.assertEquals((Integer) 2, track.getTrackNumber());
		Assert.assertEquals((Integer) 2, track.getDiscNumber());
		Assert.assertEquals((Integer) 303, track.getLength());
		Assert.assertEquals("In Your Honor", track.getAlbumName());
		Assert.assertEquals("Foo Fighters", track.getArtistName());
		Assert.assertEquals("7jy3rLJdDQY21OgRLCZ9sD", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("2eprpJCYbCbPZRKVGIEJxZ", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ALBUM_ID_ATTRIBUTE));
		Assert.assertEquals("3trcjkAjWu8qK60f4lKkGS", track.getAttribute(SpotifyJsonConverter.SPOTIFY_TRACK_ID_ATTRIBUTE));
	}
}
