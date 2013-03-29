package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Track;

public class LastFmFavouriteTracksJsonConverter extends LastFmJsonConverter implements Converter<JSONObject, Collection<Track>>
{
	@Override
	public Collection<Track> convert(JSONObject response) throws ConvertException
	{
		ArrayList<Track> result = new ArrayList<Track>();
		try
		{
			JSONObject topLevel = (JSONObject) response.get("tracks");
			JSONArray tracks = (JSONArray) topLevel.get("track");
			for (int i = 0; i < tracks.length(); i++)
			{
				JSONObject track = tracks.getJSONObject(i);
				result.add(convertTrack(track));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConvertException(ex);
		}
	}
}
