package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ContentTypeProcessor;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ContentTypeProcessorException;

public class JsonContentTypeProcessor implements ContentTypeProcessor<JSONObject>
{
	@Override
	public JSONObject processResponse(String response) throws ContentTypeProcessorException
	{
		try
		{
			return new JSONObject(response);
		}
		catch (JSONException ex)
		{
			throw new ContentTypeProcessorException(ex);
		}
	}
}
