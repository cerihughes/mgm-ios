package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Getter;

public class JsonGetter extends Getter<JSONObject>
{

	@Override
	protected JSONObject convertStringResponse(String response)
	{
		try
		{
			return new JSONObject(response);
		}
		catch (Exception e)
		{
			e.printStackTrace();
			return null;
		}
	}

	@Override
	public String getAccept()
	{
		return "application/json";
	}

}
