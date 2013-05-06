package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.List;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.IFavouriteDao;
import uk.co.cerihughes.denon.core.dao.IHistoricalDao;
import uk.co.cerihughes.denon.core.dao.IPlayableDao;
import uk.co.cerihughes.denon.core.dao.IPlaylistDao;
import uk.co.cerihughes.denon.core.dao.IRecommendationDao;
import uk.co.cerihughes.denon.core.dao.impl.RestServiceDao;
import uk.co.cerihughes.denon.core.dao.rest.impl.JsonResponseProcessor;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.MusicItem;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public class LastFmServiceDao extends RestServiceDao implements IRecommendationDao, IHistoricalDao, IFavouriteDao, IPlaylistDao,
		IPlayableDao
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

	private String getMostPlayedArtistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getTopArtists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getMostPlayedAlbumsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getTopAlbums&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getNewAlbumReleasesUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getNewReleases&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getMostPlayedTracksUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getTopTracks&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	private String getLovedTracksUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getLovedTracks&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apiKey));
	}

	public String getMobileSession(String password) throws DaoException
	{
		final LastFmMobileSessionAuthenticatorRequestBodyGenerator bodyGenerator = new LastFmMobileSessionAuthenticatorRequestBodyGenerator(
				secret, username, password);
		bodyGenerator.put("api_key", apiKey);
		bodyGenerator.put("method", "auth.getMobileSession");
		bodyGenerator.put("username", username);

		final String url = getPostUrl();
		this.sessionKey = post(url, bodyGenerator, new JsonResponseProcessor(), new LastFmMobileSessionJsonConverter());
		return this.sessionKey;
	}

	public List<Artist> getMostPlayedArtists() throws DaoException
	{
		final String url = getMostPlayedArtistsUrl();
		return get(url, new JsonResponseProcessor(), new LastFmMostPlayedArtistsJsonConverter());
	}

	public List<Artist> getRecommendedArtists() throws DaoException
	{
		final LastFmAuthenticatorRequestBodyGenerator bodyGenerator = new LastFmAuthenticatorRequestBodyGenerator(secret);
		bodyGenerator.put("method", "user.getRecommendedArtists");
		bodyGenerator.put("api_key", apiKey);
		bodyGenerator.put("sk", sessionKey);
		final String url = getPostUrl();
		return post(url, bodyGenerator, new JsonResponseProcessor(), new LastFmRecommendedArtistsJsonConverter());
	}

	@Override
	public List<Album> getRecommendedAlbums() throws DaoException
	{
		final String url = getNewAlbumReleasesUrl();
		return get(url, new JsonResponseProcessor(), new LastFmNewAlbumReleasesJsonConverter());
	}

	@Override
	public List<Track> getRecommendedTracks() throws DaoException
	{
		// TODO Auto-generated method stub
		return null;
	}

	public List<Album> getMostPlayedAlbums() throws DaoException
	{
		final String url = getMostPlayedAlbumsUrl();
		return get(url, new JsonResponseProcessor(), new LastFmMostPlayedAlbumsJsonConverter());
	}

	public List<Track> getMostPlayedTracks() throws DaoException
	{
		final String url = getMostPlayedTracksUrl();
		return get(url, new JsonResponseProcessor(), new LastFmMostPlayedTracksJsonConverter());
	}

	@Override
	public List<Artist> getFavouriteArtists() throws DaoException
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Album> getFavouriteAlbums() throws DaoException
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Track> getFavouriteTracks() throws DaoException
	{
		final String url = getLovedTracksUrl();
		return get(url, new JsonResponseProcessor(), new LastFmLovedTracksJsonConverter());
	}

	@Override
	public List<Playlist> getAllPlaylists() throws DaoException
	{
		final String url = getPlaylistsUrl();
		return get(url, new JsonResponseProcessor(), new LastFmPlaylistsJsonConverter());
	}

	@Override
	public List<Track> getTracks(Playlist playlist) throws DaoException
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void play(MusicItem item)
	{
		// TODO Auto-generated method stub

	}
}
