package uk.co.cerihughes.denon.core.dao;

import java.util.Collection;

import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public interface IFiniteServiceDao extends InfiniteServiceDao
{

	Collection<Playlist> allPlaylists() throws DaoException;

	Collection<Artist> allArtists() throws DaoException;

	Collection<Album> allAlbums() throws DaoException;

	Collection<Track> allTracks() throws DaoException;

}
