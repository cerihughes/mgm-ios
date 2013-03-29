package uk.co.cerihughes.denonpiccoloremote.core.dao.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import uk.co.cerihughes.denonpiccoloremote.core.dao.DaoException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Getter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.GetterException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.RestServiceClient;

public abstract class RestServiceDao
{

	protected String encodeParameter(String parameter)
	{
		try
		{
			return URLEncoder.encode(parameter, "ISO-8859-1");
		}
		catch (UnsupportedEncodingException e)
		{
			return parameter;
		}
	}

	protected <ResponseType, ConvertedType> ConvertedType get(String url, Getter<ResponseType> getter,
			Converter<ResponseType, ConvertedType> converter) throws DaoException
	{
		RestServiceClient<ResponseType, ConvertedType> restClient = new RestServiceClient<ResponseType, ConvertedType>(getter, converter);
		try
		{
			return restClient.get(url);
		}
		catch (GetterException ex)
		{
			throw new DaoException(ex);
		}
		catch (ConvertException ex)
		{
			throw new DaoException(ex);
		}
	}

	protected <ResponseType, ConvertedType> ConvertedType post(String url, String body, Getter<ResponseType> getter,
			Converter<ResponseType, ConvertedType> converter) throws DaoException
	{
		return null;
	}

}
