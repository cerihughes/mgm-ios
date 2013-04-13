package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.List;

import junit.framework.Assert;
import junit.framework.TestCase;

import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Artist;

public class TestSpotifyArtistSearchJsonConverter extends TestCase
{
	private static final String NO_RESULTS_JSON = "{\"info\": {\"num_results\": 0, \"limit\": 100, \"offset\": 0, \"query\": \"artist:DFGDSF\", \"type\": \"artist\", \"page\": 1}, \"artists\": []}";
	private static final String SINGLE_RESULT_JSON = "{\"info\": {\"num_results\": 1, \"limit\": 100, \"offset\": 0, \"query\": \"artist:Joanna Gruesome\", \"type\": \"artist\", \"page\": 1}, \"artists\": [{\"href\": \"spotify:artist:6K2bPQMt5xXBCfMdU5Lokj\", \"name\": \"Joanna Gruesome\", \"popularity\": \"0.00244\"}]}";
	private static final String MULTIPLE_RESULTS_JSON = "{\"info\": {\"num_results\": 42, \"limit\": 100, \"offset\": 0, \"query\": \"artist:Bj\u00f6rk\", \"type\": \"artist\", \"page\": 1}, \"artists\": [{\"href\": \"spotify:artist:7w29UYBi0qsHi5RTcv3lmA\", \"name\": \"Bj\u00f6rk\", \"popularity\": \"0.61962\"}, {\"href\": \"spotify:artist:538ZIoOw6wW1xdjuIaQHOS\", \"name\": \"Brant Bjork\", \"popularity\": \"0.27776\"}, {\"href\": \"spotify:artist:1OjcrzJpR5p38qPTskMPU5\", \"name\": \"Hera Bj\u00f6rk\", \"popularity\": \"0.11765\"}, {\"href\": \"spotify:artist:2VvFUDg4FDXzEQkQdgWz9h\", \"name\": \"Harald Bj\u00f6rk\", \"popularity\": \"0.10084\"}, {\"href\": \"spotify:artist:3tSeuQkDYNY83Kd3F8FRY4\", \"name\": \"Dirty Projectors + Bj\u00f6rk\", \"popularity\": \"0.06806\"}, {\"href\": \"spotify:artist:4ukuoWijO9BJiH2IQiPB3f\", \"name\": \"Halvar Bj\u00f6rk\", \"popularity\": \"0.00405\"}, {\"href\": \"spotify:artist:2NLt2Ctloakzf3MK7abRsf\", \"name\": \"Ingrid Bj\u00f6rk\", \"popularity\": \"0.00039\"}, {\"href\": \"spotify:artist:4jVvcUb33Gn98r7hk2AvLK\", \"name\": \"Bj\u00f6rk;Evelyn Glennie\", \"popularity\": \"0.00003\"}, {\"href\": \"spotify:artist:7ETGhZNFGDVxHKxoj2VAvK\", \"name\": \"Bjork (Karaoke)\", \"popularity\": \"0.00015\"}, {\"href\": \"spotify:artist:6HREj7kngAdjCJ2GzHWfJ1\", \"name\": \"Nina Bjork Eliasson\", \"popularity\": \"0.00013\"}, {\"href\": \"spotify:artist:0ulEOaXbMUZCZBJtsA5Ug5\", \"name\": \"Harald Bj\u00f6rk\", \"popularity\": \"0.00020\"}, {\"href\": \"spotify:artist:3bup3vA7V2SiQ30OIOEtqc\", \"name\": \"Plaid feat. Bjork\", \"popularity\": \"0.00410\"}, {\"href\": \"spotify:artist:4nhI6zTQBI1jGjKygS01LW\", \"name\": \"Brant Bjork & The Bros\", \"popularity\": \"0.00049\"}, {\"href\": \"spotify:artist:5m9AUR86h8qfJWeltKpM4q\", \"name\": \"Sven Bj\u00f6rk\", \"popularity\": \"0.00141\"}, {\"href\": \"spotify:artist:3ZRUykQOfXcFXgADWhQMsF\", \"name\": \"Bj\u00f6rk & Toffe\", \"popularity\": \"0.00196\"}, {\"href\": \"spotify:artist:0CRi15PLHVWDjwCO3cI3aB\", \"name\": \"Gosta Bjork\", \"popularity\": \"0.00002\"}, {\"href\": \"spotify:artist:5cj8VWdJeJrFC6d5c200in\", \"name\": \"Brant Bjork And The Bros\", \"popularity\": \"0.01210\"}, {\"href\": \"spotify:artist:0EbSTNyEg1FC3Lgi1LSPRe\", \"name\": \"Hera Bj\u00f6rk Feat. Haffi Haff\", \"popularity\": \"0.00038\"}, {\"href\": \"spotify:artist:6lN09oHeXYCVi92QnOgE9h\", \"name\": \"Soundtrack\\/Bjork\", \"popularity\": \"0.00190\"}, {\"href\": \"spotify:artist:6NU0lIA4bt3ZPRI58fQW4T\", \"name\": \"Bjork featuring Antony as \\\" The Conscience\\\"\", \"popularity\": \"0.00253\"}, {\"href\": \"spotify:artist:5J58YZbJGx52On04YhsyEo\", \"name\": \"Tommy Bjork\", \"popularity\": \"0.00000\"}, {\"href\": \"spotify:artist:6cfPC0NtlFvVCQ4EYQpc5r\", \"name\": \"Fredrik Bjork\", \"popularity\": \"0.00051\"}, {\"href\": \"spotify:artist:5PiHKh4tzGtI29WRmo3c5l\", \"name\": \"Bjork mit Funkstorunng\", \"popularity\": \"0.00027\"}, {\"href\": \"spotify:artist:2QGuv8ZBn9rq2j2TzOZCMA\", \"name\": \"Mikael Bjork\", \"popularity\": \"0.00002\"}, {\"href\": \"spotify:artist:4hf8aO0STZZPTeEl9geMN5\", \"name\": \"Mats Bj\u00f6rk\", \"popularity\": \"0.00003\"}, {\"href\": \"spotify:artist:0NgHsL0nbCRWXN9r68WMhu\", \"name\": \"Rasmus Bj\u00f6rk\", \"popularity\": \"0.00062\"}, {\"href\": \"spotify:artist:5qQE10NfXNAmRUat1A3U0t\", \"name\": \"Bjork Ostrom\", \"popularity\": \"0.00023\"}, {\"href\": \"spotify:artist:3o35zp2sX3r8wcPCSegiv0\", \"name\": \"Jens Bj\u00f6rk\", \"popularity\": \"0.00097\"}, {\"href\": \"spotify:artist:0s9TC4ITQhqzUJRDNWowEi\", \"name\": \"Bj\u00f6rk With The Brodsky Quartet\", \"popularity\": \"0.00036\"}, {\"href\": \"spotify:artist:2fTy8sNS4wmJrIu6uOeH8t\", \"name\": \"Bjork Gudmundsdottir & Trio Gudmundar Ingolfssonar\", \"popularity\": \"0.00168\"}, {\"href\": \"spotify:artist:6P9UBktkTlahFK6pyHw5oa\", \"name\": \"Alda Bjork\", \"popularity\": \"0.00003\"}, {\"href\": \"spotify:artist:1w1Q5YiWfce0xwaXq06Xor\", \"name\": \"Storkyrkans K\u00f6r, Torgny Bj\u00f6rk & CajsaStina \u00c5kerstr\u00f6m\", \"popularity\": \"0.00130\"}, {\"href\": \"spotify:artist:4Wt1xEqpHKvkYNApFcinnz\", \"name\": \"Torgny Bj\u00f6rk\", \"popularity\": \"0.00161\"}, {\"href\": \"spotify:artist:6W2EbLHpKmKoDZAgmLJBu0\", \"name\": \"Bjork Gudmundsdottir\", \"popularity\": \"0.00045\"}, {\"href\": \"spotify:artist:79huo0nBLuZJBVMiSMGdnT\", \"name\": \"Alda Bjork|This-Connection\", \"popularity\": \"0.00001\"}, {\"href\": \"spotify:artist:7G7FAMnyDKC8frC6DP68ve\", \"name\": \"808 State Vs. Bjork\", \"popularity\": \"0.00040\"}, {\"href\": \"spotify:artist:1sqRE7hT130Mc1BM3a1yra\", \"name\": \"Brant Bjork & The Operators\", \"popularity\": \"0.00932\"}, {\"href\": \"spotify:artist:7n8QB8DwwuZBtHhboptPeI\", \"name\": \"Bjork and Tanya Tagaq\", \"popularity\": \"0.00078\"}, {\"href\": \"spotify:artist:5wUJybcUFmAfuFsDdKZfjt\", \"name\": \"Torgny Bj\u00f6rk with Kjell Persson\", \"popularity\": \"0.00005\"}, {\"href\": \"spotify:artist:30ieUcSfiWZxZKbi6WQuwD\", \"name\": \"Emilia Bj\u00f6rk\", \"popularity\": \"0.00007\"}, {\"href\": \"spotify:artist:6Vacrvg7CB35n540R4LQKS\", \"name\": \"Bj\u00f6rk + Dirty Projectors\", \"popularity\": \"0.00000\"}, {\"href\": \"spotify:artist:1kIVIljid5trQQNnT3a6Vb\", \"name\": \"Bj\u00f8rk van der Dirk\", \"popularity\": \"0.00007\"}]}";

	private SpotifyArtistSearchJsonConverter cut;

	@Override
	public void setUp()
	{
		cut = new SpotifyArtistSearchJsonConverter();
	}

	public void testNoResults() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(NO_RESULTS_JSON);
		final List<Artist> result = cut.convert(json);
		Assert.assertEquals(0, result.size());
	}

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
		Assert.assertEquals("6K2bPQMt5xXBCfMdU5Lokj", artist.getAttribute(SpotifyJsonConverter.SPOTIFY_ARTIST_ID_ATTRIBUTE));
		Assert.assertNull(artist.getAttribute(SpotifyJsonConverter.SPOTIFY_ALBUM_ID_ATTRIBUTE));
		Assert.assertNull(artist.getAttribute(SpotifyJsonConverter.SPOTIFY_TRACK_ID_ATTRIBUTE));
		Assert.assertNull(artist.getAlbumCount());
	}

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
		Assert.assertEquals("7w29UYBi0qsHi5RTcv3lmA", artist.getAttribute(SpotifyJsonConverter.SPOTIFY_ARTIST_ID_ATTRIBUTE));
		Assert.assertNull(artist.getAttribute(SpotifyJsonConverter.SPOTIFY_ALBUM_ID_ATTRIBUTE));
		Assert.assertNull(artist.getAttribute(SpotifyJsonConverter.SPOTIFY_TRACK_ID_ATTRIBUTE));
		Assert.assertNull(artist.getAlbumCount());
	}
}
