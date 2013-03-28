package uk.co.cerihughes.denonpiccoloremote.core.dao.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Collection;

import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.DaoException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.InfiniteServiceDao;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.GetterException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.RestServiceClient;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.JsonGetter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.SpotifyArtistSearchJsonConverter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Album;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Track;

public class SpotifyServiceDao implements InfiniteServiceDao {

	private String encodeParameter(String parameter) {
		try {
			return URLEncoder.encode(parameter, "ISO-8859-1");
		} catch (UnsupportedEncodingException e) {
			return parameter;
		}
	}

	private String getArtistSearchUrl(String predicate) {
		return String.format("http://ws.spotify.com/search/1/artist?q=%s",
				encodeParameter(predicate));
	}

	private String getAlbumSearchUrl(String predicate) {
		return String.format("http://ws.spotify.com/search/1/album?q=%s",
				encodeParameter(predicate));
	}

	private String getTrackSearchUrl(String predicate) {
		return String.format("http://ws.spotify.com/search/1/track?q=%s",
				encodeParameter(predicate));
	}

	@Override
	public Collection<Playlist> searchPlaylists(String predicate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Artist> searchArtists(String predicate)
			throws DaoException {
		RestServiceClient<JSONObject, Collection<Artist>> restClient = new RestServiceClient<JSONObject, Collection<Artist>>(
				new JsonGetter(), new SpotifyArtistSearchJsonConverter());
		String url = getArtistSearchUrl(predicate);
		try {
			return restClient.get(url);
		} catch (GetterException ex) {
			throw new DaoException(ex);
		} catch (ConvertException ex) {
			throw new DaoException(ex);
		}
	}

	@Override
	public Collection<Album> searchAlbums(String predicate) {
//		JSONObject json = doGet(getAlbumSearchUrl(predicate));
		return null;
	}

	@Override
	public Collection<Album> getAlbums(Artist artist) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> searchTracks(String predicate) {
//		JSONObject json = doGet(getTrackSearchUrl(predicate));
		return null;
	}

	@Override
	public Collection<Track> getTracks(Album album) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> getTracks(Artist artist) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> getTracks(Playlist playlist) {
		// TODO Auto-generated method stub
		return null;
	}
}
