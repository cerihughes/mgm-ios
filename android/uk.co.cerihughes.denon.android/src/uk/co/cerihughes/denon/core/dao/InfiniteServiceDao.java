package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public interface InfiniteServiceDao extends IDao
{

	List<Playlist> searchPlaylists(String predicate) throws DaoException;

	List<Artist> searchArtists(String predicate) throws DaoException;

	List<Album> searchAlbums(String predicate) throws DaoException;

	List<Album> getAlbums(Artist artist) throws DaoException;

	List<Track> searchTracks(String predicate) throws DaoException;

	List<Track> getTracks(Album album) throws DaoException;

	List<Track> getTracks(Playlist playlist) throws DaoException;

}
