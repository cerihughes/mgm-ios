package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.List;

import junit.framework.Assert;

import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Track;

public class TestSpotifyTrackSearchJsonConverter
{
	private static final String NO_RESULTS_JSON = "{\"info\": {\"num_results\": 0, \"limit\": 100, \"offset\": 0, \"query\": \"jewellers to live in your dsfgdf\", \"type\": \"track\", \"page\": 1}, \"tracks\": []}";
	private static final String SINGLE_RESULT_JSON = "{\"info\": {\"num_results\": 1, \"limit\": 100, \"offset\": 0, \"query\": \"jewellers to live in your pocket\", \"type\": \"track\", \"page\": 1}, \"tracks\": [{\"album\": {\"released\": \"2011\", \"href\": \"spotify:album:71ilXXlwf8zuSMn9mpNkgx\", \"name\": \"Sleep Education\", \"availability\": {\"territories\": \"AD AE AF AG AI AL AM AN AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BM BN BO BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IN IO IQ IR IS IT JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS YE YT ZA ZM ZW ZZ\"}}, \"name\": \"To Live in Your Pocket\", \"popularity\": \"0.09644\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"GBKPL1152652\"}], \"length\": 192.217, \"href\": \"spotify:track:0j69l8EN5k7hua1TDfxK1O\", \"artists\": [{\"href\": \"spotify:artist:1GTOtEnNA0hJBwfCuoo4dg\", \"name\": \"Jewellers\"}], \"track-number\": \"8\"}]}";
	private static final String MULTIPLE_RESULTS_JSON = "{\"info\": {\"num_results\": 5, \"limit\": 100, \"offset\": 0, \"query\": \"cler achel\", \"type\": \"track\", \"page\": 1}, \"tracks\": [{\"album\": {\"released\": \"2007\", \"href\": \"spotify:album:74HnW4H7keYtcEM65MZ1sr\", \"name\": \"Aman Iman: Water Is Life\", \"availability\": {\"territories\": \"AE AF AG AI AL AM AN AO AQ AR AS AU AW AX AZ BA BB BD BF BG BH BI BJ BM BN BO BR BS BT BV BW BY BZ CC CD CF CG CI CK CL CM CN CO CR CU CV CX CY CZ DJ DK DM DO DZ EC EE EG EH ER ES ET FI FJ FK FM FO GA GB GD GE GG GH GI GL GM GN GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS JE JM JO KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LV LY MA MD ME MG MH MK ML MM MN MO MP MR MS MT MU MV MW MY MZ NA NE NF NG NI NO NP NR NU NZ OM PA PE PG PH PK PL PN PR PS PT PW PY QA RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR ST SV SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM UY UZ VA VC VE VG VI VN VU WS YE YT ZA ZM ZW ZZ\"}}, \"name\": \"Cler Achel\", \"popularity\": \"0.33358\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"GBBPF0601501\"}], \"length\": 267.828, \"href\": \"spotify:track:5uscjCcGU5eMxCoN2o1ACp\", \"artists\": [{\"href\": \"spotify:artist:2sf2owtFSCvz2MLfxmNdkb\", \"name\": \"Tinariwen\"}], \"track-number\": \"1\"}, {\"album\": {\"released\": \"2006\", \"href\": \"spotify:album:0a52UcSPETOLESPoLXtILW\", \"name\": \"Aman Iman: Water Is Life\", \"availability\": {\"territories\": \"MX PR US VI\"}}, \"name\": \"Cler Achel\", \"popularity\": \"0.26838\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USWR40606701\"}], \"length\": 267.828, \"href\": \"spotify:track:2ZHuiCY93fEub2OVzO6VdH\", \"artists\": [{\"href\": \"spotify:artist:2sf2owtFSCvz2MLfxmNdkb\", \"name\": \"Tinariwen\"}], \"track-number\": \"1\"}, {\"album\": {\"released\": \"2005\", \"href\": \"spotify:album:2j33L4yfThC5XnBEp5nZzT\", \"name\": \"Help: A Day In The Life\", \"availability\": {\"territories\": \"worldwide\"}}, \"name\": \"Cler Achel (War Child)\", \"popularity\": \"0.24263\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"GBBPF0501364\"}], \"length\": 316.536, \"href\": \"spotify:track:3jWkM4hFifj1Hrr2ZK2fIU\", \"artists\": [{\"href\": \"spotify:artist:2sf2owtFSCvz2MLfxmNdkb\", \"name\": \"Tinariwen\"}], \"track-number\": \"14\"}, {\"album\": {\"released\": \"2007\", \"href\": \"spotify:album:6DYbAf01TC8StETQll5tdh\", \"name\": \"Aman Iman (Water Is Life)\", \"availability\": {\"territories\": \"ES IT PT\"}}, \"name\": \"Cler Achel\", \"popularity\": \"0.12966\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"ITC490700013\"}], \"length\": 269.841, \"href\": \"spotify:track:0K9UfwnwH3ihyXqpCloSkU\", \"artists\": [{\"href\": \"spotify:artist:2sf2owtFSCvz2MLfxmNdkb\", \"name\": \"Tinariwen\"}], \"track-number\": \"1\"}, {\"album\": {\"released\": \"2007\", \"href\": \"spotify:album:4MJOi3V50oJcCmyoHT8Tlq\", \"name\": \"Aman Iman: Water Is Life\", \"availability\": {\"territories\": \"CA\"}}, \"name\": \"Cler Achel\", \"popularity\": \"0.00032\", \"external-ids\": [{\"type\": \"isrc\", \"id\": \"USWR40606701\"}], \"length\": 267.828, \"href\": \"spotify:track:5bzyKtGeVjaXe9J6TGpYRl\", \"artists\": [{\"href\": \"spotify:artist:2sf2owtFSCvz2MLfxmNdkb\", \"name\": \"Tinariwen\"}], \"track-number\": \"1\"}]}";

	private SpotifyTrackSearchJsonConverter cut;

	@Before
	public void setup()
	{
		cut = new SpotifyTrackSearchJsonConverter();
	}

	@Test
	public void testNoResults() throws ConverterException
	{
		final JSONObject json = new JSONObject(NO_RESULTS_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(0, result.size());
	}

	@Test
	public void testSingleResult() throws ConverterException
	{
		final JSONObject json = new JSONObject(SINGLE_RESULT_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(1, result.size());
		final Track track = result.get(0);
		Assert.assertEquals("To Live in Your Pocket", track.getName());
		Assert.assertEquals(0.09644f, track.getPopularity());
		Assert.assertEquals((Integer)8, track.getNumber());
		Assert.assertEquals((Integer)192, track.getLength());
		Assert.assertEquals("spotify:track:0j69l8EN5k7hua1TDfxK1O", track.getLocation());
		Assert.assertEquals("0j69l8EN5k7hua1TDfxK1O", track.getId());
		Assert.assertEquals("Jewellers", track.getArtistName());
		Assert.assertEquals("Sleep Education", track.getAlbumName());
		Assert.assertEquals("1GTOtEnNA0hJBwfCuoo4dg", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("71ilXXlwf8zuSMn9mpNkgx", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ALBUM_ID_ATTRIBUTE));
		Assert.assertEquals("0j69l8EN5k7hua1TDfxK1O", track.getAttribute(SpotifyJsonConverter.SPOTIFY_TRACK_ID_ATTRIBUTE));
	}

	@Test
	public void testMultipleResults() throws ConverterException
	{
		final JSONObject json = new JSONObject(MULTIPLE_RESULTS_JSON);
		final List<Track> result = cut.convert(json);
		Assert.assertEquals(5, result.size());
		final Track track = result.get(0);
		Assert.assertEquals("Cler Achel", track.getName());
		Assert.assertEquals(0.33358f, track.getPopularity());
		Assert.assertEquals((Integer)1, track.getNumber());
		Assert.assertEquals((Integer)267, track.getLength());
		Assert.assertEquals("spotify:track:5uscjCcGU5eMxCoN2o1ACp", track.getLocation());
		Assert.assertEquals("5uscjCcGU5eMxCoN2o1ACp", track.getId());
		Assert.assertEquals("Tinariwen", track.getArtistName());
		Assert.assertEquals("Aman Iman: Water Is Life", track.getAlbumName());
		Assert.assertEquals("2sf2owtFSCvz2MLfxmNdkb", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ARTIST_ID_ATTRIBUTE));
		Assert.assertEquals("74HnW4H7keYtcEM65MZ1sr", track.getAttribute(SpotifyJsonConverter.SPOTIFY_ALBUM_ID_ATTRIBUTE));
		Assert.assertEquals("5uscjCcGU5eMxCoN2o1ACp", track.getAttribute(SpotifyJsonConverter.SPOTIFY_TRACK_ID_ATTRIBUTE));
	}
}
