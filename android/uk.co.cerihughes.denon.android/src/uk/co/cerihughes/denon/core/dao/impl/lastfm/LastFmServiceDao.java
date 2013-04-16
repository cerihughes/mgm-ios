package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.List;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.impl.RestServiceDao;
import uk.co.cerihughes.denon.core.dao.rest.impl.JsonContentTypeProcessor;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public class LastFmServiceDao extends RestServiceDao
{
	private static final String API_KEY = "c906b96ff00fac94c2cde40b3f9dbf19";
	private static final String API_SECRET = "f4280454e04778b9eaaf320b977c3b78";

	private String sessionKey;
	private String apiKey;
	private String secret;
	private String username;

	public LastFmServiceDao(String sessionKey, String username)
	{
		super();
		this.sessionKey = sessionKey;
		this.username = username;
		this.apiKey = API_KEY;
		this.secret = API_SECRET;
	}

	@Override
	public EDaoType getType()
	{
		return EDaoType.LAST_FM_DIRECT;
	}

	private String getPostUrl()
	{
		return String.format("https://ws.audioscrobbler.com/2.0/?format=json");
	}

	private String getPlaylistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getPlaylists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getFavouriteArtistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getTopArtists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getFavouriteAlbumsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getTopAlbums&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getNewAlbumReleasesUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getNewReleases&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getFavouriteTracksUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getTopTracks&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	public String getMobileSession(String password) throws DaoException
	{
		final LastFmAuthenticatorHelper helper = new LastFmAuthenticatorHelper(secret);
		password = helper.md5(password);
		final String authToken = helper.md5(username + password);
		helper.put("api_key", apiKey);
		helper.put("method", "auth.getMobileSession");
		helper.put("username", username);
		helper.put("authToken", authToken);

		final String body = helper.createBody();
		final String url = getPostUrl();
		return post(url, body, new JsonContentTypeProcessor(), new LastFmMobileSessionConverter());
	}

	public List<Playlist> getPlaylists() throws DaoException
	{
		final String url = getPlaylistsUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmPlaylistsJsonConverter());
	}

	public List<Artist> getFavouriteArtists() throws DaoException
	{
		final String url = getFavouriteArtistsUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmFavouriteArtistsJsonConverter());
	}

	public List<Artist> getRecommendedArtists() throws DaoException
	{
		final LastFmAuthenticatorHelper helper = new LastFmAuthenticatorHelper(secret);
		helper.put("method", "user.getRecommendedArtists");
		helper.put("api_key", apiKey);
		helper.put("sk", sessionKey);
		final String body = helper.createBody();
		final String url = getPostUrl();
		return post(url, body, new JsonContentTypeProcessor(), new LastFmRecommendedArtistsJsonConverter());
	}

	public List<Album> getFavouriteAlbums() throws DaoException
	{
		final String url = getFavouriteAlbumsUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmFavouriteAlbumsJsonConverter());
	}

	public List<Album> getNewAlbumReleases() throws DaoException
	{
		final String url = getNewAlbumReleasesUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmNewAlbumReleasesJsonConverter());
	}

	public List<Track> getFavouriteTracks() throws DaoException
	{
		final String url = getFavouriteTracksUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmFavouriteTracksJsonConverter());
	}
}
