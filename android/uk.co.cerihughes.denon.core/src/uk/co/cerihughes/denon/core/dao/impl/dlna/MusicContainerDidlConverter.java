package uk.co.cerihughes.denon.core.dao.impl.dlna;

import org.teleal.cling.support.model.DIDLContent;
import org.teleal.cling.support.model.container.Container;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public class MusicContainerDidlConverter implements IConverter<DIDLContent, ContainerData>
{

	@Override
	public ContainerData convert(DIDLContent response) throws ConverterException
	{
		final ContainerData service = new ContainerData();
		for (Container container : response.getContainers())
		{
			final String title = container.getTitle();
			final String id = container.getId();
			if (title.equals("Playlists"))
			{
				service.setPlaylistContainerId(id);
			}
			else if (title.equals("Artist"))
			{
				service.setArtistContainerId(id);
			}
			else if (title.equals("Album"))
			{
				service.setAlbumContainerId(id);
			}
			else if (title.equals("All Tracks"))
			{
				service.setTrackContainerId(id);
			}
		}
		return service;
	}
}
