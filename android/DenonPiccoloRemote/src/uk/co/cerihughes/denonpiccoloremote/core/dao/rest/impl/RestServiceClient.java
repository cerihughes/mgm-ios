package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Getter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.GetterException;

public class RestServiceClient<ResponseType, ConvertedType>
{
	private Getter<ResponseType> getter;
	private Converter<ResponseType, ConvertedType> converter;

	public RestServiceClient(Getter<ResponseType> getter, Converter<ResponseType, ConvertedType> converter)
	{
		this.getter = getter;
		this.converter = converter;
	}

	public ConvertedType get(String url) throws GetterException, ConvertException
	{
		ResponseType response = getter.get(url);
		return converter.convert(response);
	}
}
