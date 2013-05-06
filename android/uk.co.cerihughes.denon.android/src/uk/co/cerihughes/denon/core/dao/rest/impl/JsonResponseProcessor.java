package uk.co.cerihughes.denon.core.dao.rest.impl;

import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.rest.ResponseProcessor;
import uk.co.cerihughes.denon.core.dao.rest.ResponseProcessorException;

public class JsonResponseProcessor implements ResponseProcessor<JSONObject>
{
	@Override
	public JSONObject processResponse(String response) throws ResponseProcessorException
	{
		try
		{
			return new JSONObject(response);
		}
		catch (JSONException ex)
		{
			throw new ResponseProcessorException(ex);
		}
	}
}
