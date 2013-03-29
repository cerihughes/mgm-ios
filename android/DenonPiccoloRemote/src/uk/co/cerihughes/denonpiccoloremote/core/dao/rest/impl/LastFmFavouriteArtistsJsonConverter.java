package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConverterException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;

public class LastFmFavouriteArtistsJsonConverter extends LastFmJsonConverter implements Converter<JSONObject, Collection<Artist>>
{

	@Override
	public Collection<Artist> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Artist> result = new ArrayList<Artist>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("artists");
			final JSONArray artists = topLevel.getJSONArray("artist");
			for (int i = 0; i < artists.length(); i++)
			{
				final JSONObject artist = artists.getJSONObject(i);
				result.add(convertArtist(artist));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
