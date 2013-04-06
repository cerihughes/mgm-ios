package uk.co.cerihughes.denon.core.dao.impl.dlna;

import java.util.ArrayList;
import java.util.Collection;

import org.teleal.cling.support.model.DIDLContent;
import org.teleal.cling.support.model.container.Container;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Artist;

public class ArtistContainerDidlConverter implements IConverter<DIDLContent, Collection<Artist>>
{
	@Override
	public Collection<Artist> convert(DIDLContent response) throws ConverterException
	{
		final ArrayList<Artist> result = new ArrayList<Artist>();
		for (Container container  : response.getContainers())
		{
			final Artist artist = new Artist();
			artist.setName(container.getTitle());
			artist.setAlbumCount(container.getChildCount());
			result.add(artist);
		}
		return result;
	}
}
