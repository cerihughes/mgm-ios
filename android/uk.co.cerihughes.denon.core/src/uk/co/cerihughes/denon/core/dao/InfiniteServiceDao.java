package uk.co.cerihughes.denon.core.dao;

import java.util.Collection;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public interface InfiniteServiceDao extends IDao
{

	Collection<Playlist> searchPlaylists(String predicate) throws DaoException;

	Collection<Artist> searchArtists(String predicate) throws DaoException;

	Collection<Album> searchAlbums(String predicate) throws DaoException;

	Collection<Album> getAlbums(Artist artist) throws DaoException;

	Collection<Track> searchTracks(String predicate) throws DaoException;

	Collection<Track> getTracks(Album album) throws DaoException;

	Collection<Track> getTracks(Artist artist) throws DaoException;

	Collection<Track> getTracks(Playlist playlist) throws DaoException;

}
