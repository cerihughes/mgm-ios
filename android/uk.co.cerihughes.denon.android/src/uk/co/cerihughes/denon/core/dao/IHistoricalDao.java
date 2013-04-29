package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public interface IHistoricalDao
{
	public List<Artist> getMostPlayedArtists() throws DaoException;

	public List<Album> getMostPlayedAlbums() throws DaoException;

	public List<Track> getMostPlayedTracks() throws DaoException;
}
