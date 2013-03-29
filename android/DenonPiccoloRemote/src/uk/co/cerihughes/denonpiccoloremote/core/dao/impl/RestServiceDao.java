package uk.co.cerihughes.denonpiccoloremote.core.dao.impl;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import uk.co.cerihughes.denonpiccoloremote.core.dao.DaoException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ContentTypeProcessor;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Invoker;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.RestServiceClient;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.RestServiceClientException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.GetInvoker;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl.PostInvoker;

public abstract class RestServiceDao
{
	protected static final String APPLICATION_JSON = "application/json";

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

	protected <ResponseType, ConvertedType> ConvertedType get(String url, ContentTypeProcessor<ResponseType> processor,
			Converter<ResponseType, ConvertedType> converter) throws DaoException
	{
		return get(url, null, processor, converter);
	}

	protected <ResponseType, ConvertedType> ConvertedType get(String url, String accept, ContentTypeProcessor<ResponseType> processor,
			Converter<ResponseType, ConvertedType> converter) throws DaoException
	{
		final Invoker invoker = new GetInvoker(accept);
		final RestServiceClient<ResponseType, ConvertedType> restClient = new RestServiceClient<ResponseType, ConvertedType>(invoker,
				processor, converter);
		try
		{
			return restClient.invoke(url);
		}
		catch (RestServiceClientException ex)
		{
			throw new DaoException(ex);
		}
	}

	protected <ResponseType, ConvertedType> ConvertedType post(String url, String body, ContentTypeProcessor<ResponseType> processor,
			Converter<ResponseType, ConvertedType> converter) throws DaoException
	{
		final Invoker invoker = new PostInvoker(body);
		final RestServiceClient<ResponseType, ConvertedType> restClient = new RestServiceClient<ResponseType, ConvertedType>(invoker,
				processor, converter);
		try
		{
			return restClient.invoke(url);
		}
		catch (RestServiceClientException ex)
		{
			throw new DaoException(ex);
		}
	}

}
