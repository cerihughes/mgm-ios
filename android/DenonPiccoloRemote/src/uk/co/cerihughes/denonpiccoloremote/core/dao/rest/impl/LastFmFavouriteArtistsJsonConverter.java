package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;

public class LastFmFavouriteArtistsJsonConverter extends LastFmJsonConverter implements Converter<JSONObject, Collection<Artist>>
{

	@Override
	public Collection<Artist> convert(JSONObject response) throws ConvertException
	{
		ArrayList<Artist> result = new ArrayList<Artist>();
		try
		{
			JSONObject topLevel = (JSONObject) response.get("artists");
			JSONArray artists = (JSONArray) topLevel.get("artist");
			for (int i = 0; i < artists.length(); i++)
			{
				JSONObject artist = artists.getJSONObject(i);
				result.add(convertArtist(artist));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConvertException(ex);
		}
	}
}
