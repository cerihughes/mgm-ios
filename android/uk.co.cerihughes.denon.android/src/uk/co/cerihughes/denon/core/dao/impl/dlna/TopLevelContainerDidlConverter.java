package uk.co.cerihughes.denon.core.dao.impl.dlna;

import java.util.ArrayList;
import java.util.Collection;

import org.teleal.cling.support.model.DIDLContent;
import org.teleal.cling.support.model.container.Container;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public class TopLevelContainerDidlConverter implements IConverter<DIDLContent, Collection<String>>
{
	@Override
	public Collection<String> convert(DIDLContent response) throws ConverterException
	{
		final ArrayList<String> result = new ArrayList<String>();
		for (Container container : response.getContainers())
		{
			if (container.getTitle().equals("Music"))
			{
				result.add(container.getId());
			}
		}
		return result;
	}
}
