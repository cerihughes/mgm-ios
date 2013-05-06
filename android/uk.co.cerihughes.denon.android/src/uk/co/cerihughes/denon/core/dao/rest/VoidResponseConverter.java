package uk.co.cerihughes.denon.core.dao.rest;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;

public class VoidResponseConverter implements IConverter<String, Void>
{
	@Override
	public Void convert(String response)
	{
		return null;
	}
}
