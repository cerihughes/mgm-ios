package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConverterException;

public class LastFmMobileSessionConverter extends LastFmJsonConverter implements Converter<JSONObject, String>
{

	/**
	 * Process:
	 * 
	 * <code>
	 * {"session":{"name":"arkanoid","key":"<session_key>","subscriber":"0"}}
	 * </code>
	 */
	@Override
	public String convert(JSONObject response) throws ConverterException
	{
		try
		{
			final JSONObject topLevel = (JSONObject) response.get("session");
			return topLevel.getString("key");
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
