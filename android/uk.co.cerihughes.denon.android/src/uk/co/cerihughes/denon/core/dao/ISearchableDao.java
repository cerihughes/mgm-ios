package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public interface ISearchableDao extends IDao
{
	List<Track> searchTrack(String artistName, String trackName) throws DaoException;

	List<Track> searchTracks(String trackName) throws DaoException;

	List<Album> searchAlbums(String albumName) throws DaoException;

	List<Album> searchAlbums(String artistName, String albumName) throws DaoException;

	List<Artist> searchArtists(String artistName) throws DaoException;
}
