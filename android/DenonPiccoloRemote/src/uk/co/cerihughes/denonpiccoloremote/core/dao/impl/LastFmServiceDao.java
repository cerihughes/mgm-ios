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

	private String apikey;
	private String username;

	public LastFmServiceDao(String apikey, String username)
	{
		super();
		this.apikey = apikey;
		this.username = username;
	}

	private String getPlaylistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getplaylists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	private String getFavouriteArtistsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.getartists&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	// TODO: This
	// private String getRecommendedArtistsUrl(String predicate) {
	// return String.format("http://ws.spotify.com/search/1/artist?q=%s",
	// encodeParameter(predicate));
	// }

	private String getFavouriteAlbumsUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=library.getalbums&user=%s&api_key=%s&format=json",
				encodeParameter(username), encodeParameter(apikey));
	}

	private String getNewAlbumReleasesUrl()
	{
		return String.format("http://ws.audioscrobbler.com/2.0/?method=user.getnewreleases&user=%s&api_key=%s&format=json",
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
