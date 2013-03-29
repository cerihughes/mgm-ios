package uk.co.cerihughes.denonpiccoloremote.core.dao.impl;

import java.util.Collection;

import uk.co.cerihughes.denonpiccoloremote.core.dao.DaoException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.JsonGetter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.LastFmFavouriteAlbumsJsonConverter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.LastFmFavouriteArtistsJsonConverter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.LastFmFavouriteTracksJsonConverter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.LastFmNewAlbumReleasesJsonConverter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.LastFmPlaylistsJsonConverter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Album;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Track;

public class LastFmServiceDao extends RestServiceDao
{
	private String sessionKey;
	private String apikey;
	private String username;

	public LastFmServiceDao(String sessionKey, String apikey, String username)
	{
		super();
		this.sessionKey = sessionKey;
		this.apikey = apikey;
		this.username = username;
	}

	private String getPlaylistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getPlaylists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	private String getFavouriteArtistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.getArtists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	private String getRecommendedArtistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getRecommendedArtists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	private String getFavouriteAlbumsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.getAlbums&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	private String getNewAlbumReleasesUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getNewReleases&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	private String getFavouriteTracksUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.gettracks&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	public Collection<Playlist> getPlaylists() throws DaoException
	{
		final String url = getPlaylistsUrl();
		return get(url, new JsonGetter(), new LastFmPlaylistsJsonConverter());
	}

	public Collection<Artist> getFavouriteArtists() throws DaoException
	{
		final String url = getFavouriteArtistsUrl();
		return get(url, new JsonGetter(), new LastFmFavouriteArtistsJsonConverter());
	}

	public Collection<Album> getFavouriteAlbums() throws DaoException
	{
		final String url = getFavouriteAlbumsUrl();
		return get(url, new JsonGetter(), new LastFmFavouriteAlbumsJsonConverter());
	}

	public Collection<Album> getNewAlbumReleases() throws DaoException
	{
		final String url = getNewAlbumReleasesUrl();
		return get(url, new JsonGetter(), new LastFmNewAlbumReleasesJsonConverter());
	}

	public Collection<Track> getFavouriteTracks() throws DaoException
	{
		final String url = getFavouriteTracksUrl();
		return get(url, new JsonGetter(), new LastFmFavouriteTracksJsonConverter());
	}
}
