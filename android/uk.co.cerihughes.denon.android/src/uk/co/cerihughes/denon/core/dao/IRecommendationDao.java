package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public interface IRecommendationDao
{
	public List<Artist> getRecommendedArtists() throws DaoException;
	public List<Album> getRecommendedAlbums() throws DaoException;
	public List<Track> getRecommendedTracks() throws DaoException;
}
