package uk.co.cerihughes.denon.core.dao.impl.dlna;

import org.teleal.cling.model.meta.LocalDevice;
import org.teleal.cling.model.meta.RemoteDevice;
import org.teleal.cling.model.meta.RemoteService;
import org.teleal.cling.registry.Registry;
import org.teleal.cling.registry.RegistryListener;

public class MainRegistryListener implements RegistryListener
{
	private MainRegistryListenerDelegate delegate;

	public MainRegistryListener(MainRegistryListenerDelegate delegate)
	{
		super();
		this.delegate = delegate;
	}

	@Override
	public void remoteDeviceDiscoveryStarted(Registry registry, RemoteDevice device)
	{
	}

	@Override
	public void remoteDeviceDiscoveryFailed(Registry registry, RemoteDevice device, Exception ex)
	{
	}

	@Override
	public void remoteDeviceAdded(Registry registry, RemoteDevice device)
	{
		if (isMediaServer(device))
		{
			remoteMediaServerAdded(device);
		}
	}

	@Override
	public void remoteDeviceUpdated(Registry registry, RemoteDevice device)
	{
	}

	@Override
	public void remoteDeviceRemoved(Registry registry, RemoteDevice device)
	{
	}

	@Override
	public void localDeviceAdded(Registry registry, LocalDevice device)
	{
	}

	@Override
	public void localDeviceRemoved(Registry registry, LocalDevice device)
	{
	}

	@Override
	public void beforeShutdown(Registry registry)
	{
	}

	@Override
	public void afterShutdown()
	{
	}

	public void remoteMediaServerAdded(RemoteDevice remoteDevice)
	{
		for (RemoteService remoteService : remoteDevice.getServices())
		{
			if (remoteService.getServiceType().getType().equals("ContentDirectory"))
			{
				if (delegate != null)
				{
					delegate.contentDirectoryAdded(remoteDevice, remoteService);
				}
			}
		}
	}

	private boolean isMediaServer(RemoteDevice device)
	{
		return (device.getType().getType().equals("MediaServer"));
	}

}
