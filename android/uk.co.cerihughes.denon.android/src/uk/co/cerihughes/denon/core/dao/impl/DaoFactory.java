package uk.co.cerihughes.denon.core.dao.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.teleal.cling.UpnpService;
import org.teleal.cling.model.message.header.STAllHeader;
import org.teleal.cling.model.meta.RemoteDevice;
import org.teleal.cling.model.meta.RemoteService;
import org.teleal.cling.registry.RegistryListener;
import org.teleal.cling.support.model.BrowseFlag;
import org.teleal.cling.support.model.DIDLContent;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.IDao;
import uk.co.cerihughes.denon.core.dao.IDaoFactory;
import uk.co.cerihughes.denon.core.dao.IDaoFactoryListener;
import uk.co.cerihughes.denon.core.dao.impl.dlna.ContainerData;
import uk.co.cerihughes.denon.core.dao.impl.dlna.DlnaServiceDao;
import uk.co.cerihughes.denon.core.dao.impl.dlna.MainRegistryListener;
import uk.co.cerihughes.denon.core.dao.impl.dlna.MainRegistryListenerDelegate;
import uk.co.cerihughes.denon.core.dao.impl.dlna.MusicContainerDidlConverter;
import uk.co.cerihughes.denon.core.dao.impl.dlna.SynchronousBrowse;
import uk.co.cerihughes.denon.core.dao.impl.dlna.TopLevelContainerDidlConverter;
import uk.co.cerihughes.denon.core.dao.impl.lastfm.LastFmServiceDao;
import uk.co.cerihughes.denon.core.dao.impl.spotify.SpotifyServiceDao;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public abstract class DaoFactory implements IDaoFactory, MainRegistryListenerDelegate
{
	private final SpotifyServiceDao spotifyDirectDao = new SpotifyServiceDao();
	private final LastFmServiceDao lastFmDirectDao = new LastFmServiceDao(null, "hughesceritest");
	private final ArrayList<IDaoFactoryListener> listeners = new ArrayList<IDaoFactoryListener>();
	private final MainRegistryListener registryListener = new MainRegistryListener(this);
	private UpnpService upnpService;

	protected abstract UpnpService createUpnpService(RegistryListener listener);

	@Override
	public void start()
	{
		notifyListeners(spotifyDirectDao, true);
		notifyListeners(lastFmDirectDao, true);
		upnpService = createUpnpService(registryListener);
		upnpService.getControlPoint().search(new STAllHeader());
	}

	@Override
	public void stop()
	{
		if (upnpService != null)
		{
			upnpService.shutdown();
			upnpService.getRegistry().removeListener(registryListener);
			upnpService = null;
		}
		notifyListeners(spotifyDirectDao, false);
		notifyListeners(lastFmDirectDao, false);
	}

	@Override
	public void addListener(IDaoFactoryListener listener)
	{
		listeners.add(listener);
	}

	@Override
	public void removeListener(IDaoFactoryListener listener)
	{
		listeners.remove(listener);
	}

	private void notifyListeners(IDao dao, boolean added)
	{
		for (IDaoFactoryListener listener : listeners)
		{
			if (added)
			{
				listener.daoAdded(dao);
			}
			else
			{
				listener.daoRemoved(dao);
			}
		}
	}

	@Override
	public void contentDirectoryAdded(RemoteDevice remoteDevice, RemoteService remoteService)
	{
		try
		{
			for (String musicContainerId : musicContainerIdsForService(remoteService))
			{
				try
				{
					final ContainerData containerData = containerDataForService(remoteService, musicContainerId);
					final DlnaServiceDao dao = new DlnaServiceDao(upnpService, remoteService, containerData);
					notifyListeners(dao, true);
				}
				catch (DaoException ex)
				{
					ex.printStackTrace();
				}
			}
		}
		catch (DaoException ex)
		{
			ex.printStackTrace();
		}
	}

	private Collection<String> musicContainerIdsForService(RemoteService remoteService) throws DaoException
	{
		final SynchronousBrowse browse = new SynchronousBrowse();
		final DIDLContent response = browse.browse(upnpService, remoteService, "0", BrowseFlag.DIRECT_CHILDREN, DlnaServiceDao.TIMEOUT);
		final TopLevelContainerDidlConverter container = new TopLevelContainerDidlConverter();
		try
		{
			return container.convert(response);
		}
		catch (ConverterException ex)
		{
			throw new DaoException(ex);
		}
	}

	private ContainerData containerDataForService(RemoteService remoteService, String musicContainerId) throws DaoException
	{
		final SynchronousBrowse browse = new SynchronousBrowse();
		final DIDLContent response = browse.browse(upnpService, remoteService, musicContainerId, BrowseFlag.DIRECT_CHILDREN,
				DlnaServiceDao.TIMEOUT);
		final MusicContainerDidlConverter container = new MusicContainerDidlConverter();
		try
		{
			return container.convert(response);
		}
		catch (ConverterException ex)
		{
			throw new DaoException(ex);
		}
	}

}
