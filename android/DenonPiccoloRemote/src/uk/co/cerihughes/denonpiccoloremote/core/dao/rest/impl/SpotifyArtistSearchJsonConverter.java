package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConverterException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;

public class SpotifyArtistSearchJsonConverter implements Converter<JSONObject, Collection<Artist>>
{

	@Override
	public Collection<Artist> convert(JSONObject response) throws ConverterException
	{
		ArrayList<Artist> result = new ArrayList<Artist>();
		try
		{
			final JSONObject info = (JSONObject) response.get("info");
			final JSONArray artists = (JSONArray) response.get("artists");
			for (int i = 0; i < artists.length(); i++)
			{
				JSONObject artist = artists.getJSONObject(i);
				result.add(convertArtist(artist));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}

	private Artist convertArtist(JSONObject json) throws JSONException
	{
		final Artist artist = new Artist();
		final String href = json.getString("href");
		final String name = json.getString("name");
		final String popularity = json.getString("popularity");
		Float popularityFloat;
		try
		{
			popularityFloat = Float.parseFloat(popularity);
		}
		catch (NumberFormatException ex)
		{
			popularityFloat = null;
		}

		artist.setName(name);
		artist.setLocation(href);
		artist.setPopularity(popularityFloat);

		return artist;
	}
}
