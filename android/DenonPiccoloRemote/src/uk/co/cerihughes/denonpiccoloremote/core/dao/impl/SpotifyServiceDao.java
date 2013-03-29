package uk.co.cerihughes.denonpiccoloremote.core.dao.impl;

import java.util.Collection;

import uk.co.cerihughes.denonpiccoloremote.core.dao.DaoException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.InfiniteServiceDao;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.JsonGetter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.SpotifyArtistSearchJsonConverter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Album;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Track;

public class SpotifyServiceDao extends RestServiceDao implements InfiniteServiceDao
{

	private String getArtistSearchUrl(String predicate)
	{
		return String.format("http://ws.spotify.com/search/1/artist?q=%s", encodeParameter(predicate));
	}

	private String getAlbumSearchUrl(String predicate)
	{
		return String.format("http://ws.spotify.com/search/1/album?q=%s", encodeParameter(predicate));
	}

	private String getTrackSearchUrl(String predicate)
	{
		return String.format("http://ws.spotify.com/search/1/track?q=%s", encodeParameter(predicate));
	}

	@Override
	public Collection<Playlist> searchPlaylists(String predicate)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Artist> searchArtists(String predicate) throws DaoException
	{
		final String url = getArtistSearchUrl(predicate);
		return get(url, new JsonGetter(), new SpotifyArtistSearchJsonConverter());
	}

	@Override
	public Collection<Album> searchAlbums(String predicate)
	{
		// JSONObject json = doGet(getAlbumSearchUrl(predicate));
		return null;
	}

	@Override
	public Collection<Album> getAlbums(Artist artist)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> searchTracks(String predicate)
	{
		// JSONObject json = doGet(getTrackSearchUrl(predicate));
		return null;
	}

	@Override
	public Collection<Track> getTracks(Album album)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> getTracks(Artist artist)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> getTracks(Playlist playlist)
	{
		// TODO Auto-generated method stub
		return null;
	}
}
