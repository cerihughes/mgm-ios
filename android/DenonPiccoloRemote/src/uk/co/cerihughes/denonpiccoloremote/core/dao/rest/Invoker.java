package uk.co.cerihughes.denonpiccoloremote.core.dao.rest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.impl.client.DefaultHttpClient;

public abstract class Invoker
{
	public String invoke(String url) throws InvokerException
	{
		final HttpClient client = new DefaultHttpClient();
		final HttpRequestBase requestBase = getRequestBase(url);
		try
		{
			final HttpResponse response = client.execute(requestBase);
			final StatusLine statusLine = response.getStatusLine();
			final int statusCode = statusLine.getStatusCode();
			final HttpEntity entity = response.getEntity();
			final InputStream content = entity.getContent();
			final BufferedReader reader = new BufferedReader(new InputStreamReader(content));

			final StringBuilder sb = new StringBuilder();
			String line;
			while ((line = reader.readLine()) != null)
			{
				sb.append(line);
			}
			final String responseBody = sb.toString();
			if (statusCode == 200)
			{
				return responseBody;
			}
			else
			{
				throw new InvokerException(String.format("Unexpected response [%d] for url [%s] : [%s].", statusCode, url, responseBody));
			}
		}
		catch (ClientProtocolException ex)
		{
			throw new InvokerException(ex);
		}
		catch (IOException ex)
		{
			throw new InvokerException(ex);
		}
	}

	protected abstract HttpRequestBase getRequestBase(String url) throws InvokerException;
}
