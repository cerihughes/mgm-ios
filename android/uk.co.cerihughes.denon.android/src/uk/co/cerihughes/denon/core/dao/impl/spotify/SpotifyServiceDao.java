package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.List;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.IHierarchicalDao;
import uk.co.cerihughes.denon.core.dao.IPlayableDao;
import uk.co.cerihughes.denon.core.dao.ISearchableDao;
import uk.co.cerihughes.denon.core.dao.impl.RestServiceDao;
import uk.co.cerihughes.denon.core.dao.rest.impl.JsonResponseProcessor;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.MusicItem;
import uk.co.cerihughes.denon.core.model.Track;

public class SpotifyServiceDao extends RestServiceDao implements IHierarchicalDao, ISearchableDao, IPlayableDao
{
	@Override
	public EDaoType getType()
	{
		return EDaoType.SPOTIFY_DIRECT;
	}

	private String getArtistSearchUrl(String predicate)
	{
		return String.format("http://ws.spotify.com/search/1/artist?q=%s", encodeParameter(predicate));
	}

	private String getAlbumSearchUrl(String predicate)
	{
		return String.format("http://ws.spotify.com/search/1/album?q=%s", encodeParameter(predicate));
	}

	private String getAlbumsForArtistUrl(String artistId)
	{
		return String.format("http://ws.spotify.com/lookup/1/.json?uri=spotify:artist:%s&extras=albumdetail", encodeParameter(artistId));
	}

	private String getTrackSearchUrl(String predicate)
	{
		return String.format("http://ws.spotify.com/search/1/track?q=%s", encodeParameter(predicate));
	}

	private String getTracksForAlbumUrl(String albumId)
	{
		return String.format("http://ws.spotify.com/lookup/1/.json?uri=spotify:track:%s&extras=trackdetail", encodeParameter(albumId));
	}

	@Override
	public List<Artist> searchArtists(String predicate) throws DaoException
	{
		final String url = getArtistSearchUrl(predicate);
		return get(url, APPLICATION_JSON, new JsonResponseProcessor(), new SpotifyArtistSearchJsonConverter());
	}

	@Override
	public List<Album> searchAlbums(String predicate) throws DaoException
	{
		final String url = getAlbumSearchUrl(predicate);
		return get(url, APPLICATION_JSON, new JsonResponseProcessor(), new SpotifyAlbumSearchJsonConverter());
	}
	
	@Override
	public List<Album> searchAlbums(String artistName, String albumName) throws DaoException
	{
		final String predicate = String.format("%s %s", artistName, albumName);
		return searchAlbums(predicate);
	}

	@Override
	public List<Album> getAlbums(Artist artist) throws DaoException
	{
		final String artistId = artist.getAttribute(SpotifyJsonConverter.SPOTIFY_ARTIST_ID_ATTRIBUTE);
		if (artistId != null)
		{
			final String url = getAlbumsForArtistUrl(artistId);
			return get(url, APPLICATION_JSON, new JsonResponseProcessor(), new SpotifyAlbumsForArtistJsonConverter());
		}
		throw new DaoException("Not a Spotify artist.");
	}

	@Override
	public List<Track> searchTracks(String predicate) throws DaoException
	{
		final String url = getTrackSearchUrl(predicate);
		return get(url, APPLICATION_JSON, new JsonResponseProcessor(), new SpotifyTrackSearchJsonConverter());
	}
	
	@Override
	public List<Track> searchTrack(String artistName, String trackName) throws DaoException
	{
		final String predicate = String.format("%s %s", artistName, trackName);
		return searchTracks(predicate);
	}

	@Override
	public List<Track> getTracks(Album album) throws DaoException
	{
		final String albumId = album.getAttribute(SpotifyJsonConverter.SPOTIFY_ALBUM_ID_ATTRIBUTE);
		if (albumId != null)
		{
			final String url = getTracksForAlbumUrl(albumId);
			return get(url, APPLICATION_JSON, new JsonResponseProcessor(), new SpotifyTracksForAlbumJsonConverter());
		}
		throw new DaoException("Not a Spotify album.");
	}

	@Override
	public void play(MusicItem item)
	{
		// TODO Auto-generated method stub
		
	}
}
