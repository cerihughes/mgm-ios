package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.io.UnsupportedEncodingException;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpRequestBase;
import org.apache.http.entity.StringEntity;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Invoker;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.InvokerException;

public class PostInvoker extends Invoker
{
	private String body;

	public PostInvoker(String body)
	{
		super();
		this.body = body;
	}

	@Override
	protected HttpRequestBase getRequestBase(String url) throws InvokerException
	{
		final HttpPost post = new HttpPost(url);
		if (body != null)
		{
			try
			{
				final HttpEntity entity = new StringEntity(body, "UTF-8");
				post.setEntity(entity);
			}
			catch (UnsupportedEncodingException ex)
			{
				throw new InvokerException(ex);
			}
		}
		return post;
	}
}