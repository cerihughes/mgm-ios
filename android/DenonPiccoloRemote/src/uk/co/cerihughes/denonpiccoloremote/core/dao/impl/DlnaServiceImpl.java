package uk.co.cerihughes.denonpiccoloremote.core.dao.impl;

import java.util.Collection;

import uk.co.cerihughes.denonpiccoloremote.core.dao.FiniteServiceDao;
import uk.co.cerihughes.denonpiccoloremote.core.model.Album;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;
import uk.co.cerihughes.denonpiccoloremote.core.model.Track;

public class DlnaServiceImpl implements FiniteServiceDao {

	@Override
	public Collection<Playlist> searchPlaylists(String predicate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Artist> searchArtists(String predicate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Album> searchAlbums(String predicate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Album> getAlbums(Artist artist) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> searchTracks(String predicate) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> getTracks(Album album) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> getTracks(Artist artist) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> getTracks(Playlist playlist) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Playlist> allPlaylists() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Artist> allArtists() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Album> allAlbums() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Collection<Track> allTracks() {
		// TODO Auto-generated method stub
		return null;
	}

}
