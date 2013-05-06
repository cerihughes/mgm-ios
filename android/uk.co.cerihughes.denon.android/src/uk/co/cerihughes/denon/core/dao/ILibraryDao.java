package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public interface ILibraryDao extends IDao
{
	List<Artist> getAllArtists() throws DaoException;

	List<Album> getAllAlbums() throws DaoException;

	List<Track> getAllTracks() throws DaoException;
}
