package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public interface IHierarchicalDao extends IDao
{
	List<Album> getAlbums(Artist artist) throws DaoException;

	List<Track> getTracks(Album album) throws DaoException;
}
