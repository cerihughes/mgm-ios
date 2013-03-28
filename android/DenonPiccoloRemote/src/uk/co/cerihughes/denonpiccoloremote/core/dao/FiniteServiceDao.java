package uk.co.cerihughes.denonpiccoloremote.core.dao;

import java.util.Collection;

import uk.co.cerihughes.denonpiccoloremote.core.model.Album;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Track;

public interface FiniteServiceDao extends InfiniteServiceDao {

	Collection<Playlist> allPlaylists() throws DaoException;

	Collection<Artist> allArtists() throws DaoException;

	Collection<Album> allAlbums() throws DaoException;

	Collection<Track> allTracks() throws DaoException;

}
