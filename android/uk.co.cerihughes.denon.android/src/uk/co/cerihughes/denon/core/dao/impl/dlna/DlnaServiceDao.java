package uk.co.cerihughes.denon.core.dao.impl.dlna;

import java.util.List;

import org.teleal.cling.UpnpService;
import org.teleal.cling.model.meta.RemoteService;
import org.teleal.cling.support.model.BrowseFlag;
import org.teleal.cling.support.model.DIDLContent;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.IFiniteServiceDao;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public class DlnaServiceDao implements IFiniteServiceDao
{
	public static final int TIMEOUT = 10;

	private final UpnpService upnpService;
	private final RemoteService remoteService;
	private final ContainerData containerData;

	public DlnaServiceDao(UpnpService upnpService, RemoteService remoteService, ContainerData containerData)
	{
		super();
		this.upnpService = upnpService;
		this.remoteService = remoteService;
		this.containerData = containerData;
	}

	@Override
	public EDaoType getType()
	{
		return EDaoType.DLNA_DIRECT;
	}

	@Override
	public void start()
	{
		// TODO Auto-generated method stub

	}

	@Override
	public void stop()
	{
		// TODO Auto-generated method stub

	}

	@Override
	public List<Playlist> searchPlaylists(String predicate)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Artist> searchArtists(String predicate)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Album> searchAlbums(String predicate)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Album> getAlbums(Artist artist)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Track> searchTracks(String predicate)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Track> getTracks(Album album)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Track> getTracks(Playlist playlist)
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Playlist> allPlaylists()
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Artist> allArtists() throws DaoException
	{
		final SynchronousBrowse browse = new SynchronousBrowse();
		final DIDLContent response = browse.browse(upnpService, remoteService, containerData.getArtistContainerId(),
				BrowseFlag.DIRECT_CHILDREN, TIMEOUT);
		final ArtistContainerDidlConverter container = new ArtistContainerDidlConverter();
		try
		{
			return container.convert(response);
		}
		catch (ConverterException ex)
		{
			throw new DaoException(ex);
		}
	}

	@Override
	public List<Album> allAlbums() throws DaoException
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<Track> allTracks()
	{
		// TODO Auto-generated method stub
		return null;
	}
}
