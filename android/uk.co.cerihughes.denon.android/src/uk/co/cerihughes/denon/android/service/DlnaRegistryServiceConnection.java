package uk.co.cerihughes.denon.android.service;

import org.teleal.cling.android.AndroidUpnpService;
import org.teleal.cling.model.meta.RemoteDevice;
import org.teleal.cling.model.meta.RemoteService;
import org.teleal.cling.registry.Registry;

import uk.co.cerihughes.denon.core.dao.impl.dlna.MainRegistryListener;
import uk.co.cerihughes.denon.core.dao.impl.dlna.MainRegistryListenerDelegate;
import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;

public class DlnaRegistryServiceConnection implements ServiceConnection, MainRegistryListenerDelegate
{
	private MainRegistryListener registryListener = new MainRegistryListener(this);

	private AndroidUpnpService upnpService;

	@Override
	public void onServiceConnected(ComponentName className, IBinder service)
	{
		upnpService = (AndroidUpnpService) service;
		final Registry registry = upnpService.getRegistry();
		for (RemoteDevice device : registry.getRemoteDevices())
		{
			registryListener.remoteDeviceAdded(registry, device);
		}

		// Getting ready for future device advertisements
		upnpService.getRegistry().addListener(registryListener);

		// Search asynchronously for all devices
		upnpService.getControlPoint().search();
	}

	@Override
	public void onServiceDisconnected(ComponentName className)
	{
		if (upnpService != null)
		{
			upnpService.getRegistry().removeListener(registryListener);
			upnpService = null;
		}
	}

	@Override
	public void contentDirectoryAdded(RemoteDevice remoteDevice, RemoteService contentDirectory)
	{
	}

}
