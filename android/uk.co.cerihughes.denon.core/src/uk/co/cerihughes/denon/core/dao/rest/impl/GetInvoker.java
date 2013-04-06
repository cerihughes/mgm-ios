package uk.co.cerihughes.denon.core.dao.rest.impl;

import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpRequestBase;

import uk.co.cerihughes.denon.core.dao.rest.Invoker;

public class GetInvoker extends Invoker
{
	private String accept;

	public GetInvoker()
	{
		super();
	}

	public GetInvoker(String accept)
	{
		this();
		this.accept = accept;
	}

	@Override
	protected HttpRequestBase getRequestBase(String url)
	{
		final HttpGet get = new HttpGet(url);
		if (accept != null)
		{
			get.addHeader("Accept", accept);
		}
		return get;
	}
}
