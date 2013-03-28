package uk.co.cerihughes.denonpiccoloremote.core.dao;

import java.util.Collection;

import uk.co.cerihughes.denonpiccoloremote.core.model.Album;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Track;

public interface InfiniteServiceDao {

	Collection<Playlist> searchPlaylists(String predicate) throws DaoException;

	Collection<Artist> searchArtists(String predicate) throws DaoException;

	Collection<Album> searchAlbums(String predicate) throws DaoException;

	Collection<Album> getAlbums(Artist artist) throws DaoException;

	Collection<Track> searchTracks(String predicate) throws DaoException;

	Collection<Track> getTracks(Album album) throws DaoException;

	Collection<Track> getTracks(Artist artist) throws DaoException;

	Collection<Track> getTracks(Playlist playlist) throws DaoException;

}
