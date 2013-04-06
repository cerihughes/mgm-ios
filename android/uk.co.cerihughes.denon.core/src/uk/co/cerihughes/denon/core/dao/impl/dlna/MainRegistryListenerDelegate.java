package uk.co.cerihughes.denon.core.dao.impl.dlna;

import org.teleal.cling.model.meta.RemoteDevice;
import org.teleal.cling.model.meta.RemoteService;

public interface MainRegistryListenerDelegate
{
	void contentDirectoryAdded(RemoteDevice remoteDevice, RemoteService contentDirectory);
}
