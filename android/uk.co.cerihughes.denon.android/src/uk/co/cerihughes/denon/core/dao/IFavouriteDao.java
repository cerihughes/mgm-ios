package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public interface IFavouriteDao
{
	public List<Artist> getFavouriteArtists() throws DaoException;

	public List<Album> getFavouriteAlbums() throws DaoException;

	public List<Track> getFavouriteTracks() throws DaoException;
}
