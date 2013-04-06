package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.Collection;

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
	private String sessionKey;
	private String apiKey;
	private String secret;
	private String username;

	public LastFmServiceDao(String sessionKey, String apiKey, String secret, String username)
	{
		super();
		this.sessionKey = sessionKey;
		this.apiKey = apiKey;
		this.username = username;
		this.secret = secret;
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
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.getArtists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getFavouriteAlbumsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.getAlbums&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getNewAlbumReleasesUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getNewReleases&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getFavouriteTracksUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.gettracks&user=%s&api_key=%s&format=json",
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

	public Collection<Playlist> getPlaylists() throws DaoException
	{
		final String url = getPlaylistsUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmPlaylistsJsonConverter());
	}

	public Collection<Artist> getFavouriteArtists() throws DaoException
	{
		final String url = getFavouriteArtistsUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmFavouriteArtistsJsonConverter());
	}

	public Collection<Artist> getRecommendedArtists() throws DaoException
	{
		final LastFmAuthenticatorHelper helper = new LastFmAuthenticatorHelper(secret);
		helper.put("method", "user.getRecommendedArtists");
		helper.put("api_key", apiKey);
		helper.put("sk", sessionKey);
		final String body = helper.createBody();
		final String url = getPostUrl();
		return post(url, body, new JsonContentTypeProcessor(), new LastFmRecommendedArtistsJsonConverter());
	}

	public Collection<Album> getFavouriteAlbums() throws DaoException
	{
		final String url = getFavouriteAlbumsUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmFavouriteAlbumsJsonConverter());
	}

	public Collection<Album> getNewAlbumReleases() throws DaoException
	{
		final String url = getNewAlbumReleasesUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmNewAlbumReleasesJsonConverter());
	}

	public Collection<Track> getFavouriteTracks() throws DaoException
	{
		final String url = getFavouriteTracksUrl();
		return get(url, new JsonContentTypeProcessor(), new LastFmFavouriteTracksJsonConverter());
	}
}
