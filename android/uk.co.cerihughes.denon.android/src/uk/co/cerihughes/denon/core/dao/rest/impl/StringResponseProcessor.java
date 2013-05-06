package uk.co.cerihughes.denon.core.dao.rest.impl;

import uk.co.cerihughes.denon.core.dao.rest.ResponseProcessor;
import uk.co.cerihughes.denon.core.dao.rest.ResponseProcessorException;

public class StringResponseProcessor implements ResponseProcessor<String>
{
	@Override
	public String processResponse(String response) throws ResponseProcessorException
	{
		return response;
	}
}
