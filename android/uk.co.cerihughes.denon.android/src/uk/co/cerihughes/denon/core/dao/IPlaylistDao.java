package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public interface IPlaylistDao extends IDao
{
	List<Playlist> allPlaylists() throws DaoException;

	List<Track> getTracks(Playlist playlist) throws DaoException;
}
