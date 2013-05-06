package uk.co.cerihughes.denon.core.dao.rest.impl;

import uk.co.cerihughes.denon.core.dao.rest.RequestBodyGenerator;

public class StringRequestBodyGenerator implements RequestBodyGenerator
{
	private final String body;

	public StringRequestBodyGenerator(String body)
	{
		super();
		this.body = body;
	}

	@Override
	public String generateRequestBody()
	{
		return body;
	}
}
