package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public class LastFmMobileSessionConverter extends LastFmJsonConverter implements IConverter<JSONObject, String>
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
