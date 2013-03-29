package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConverterException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Album;

public class LastFmFavouriteAlbumsJsonConverter extends LastFmJsonConverter implements Converter<JSONObject, Collection<Album>>
{

	@Override
	public Collection<Album> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Album> result = new ArrayList<Album>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("albums");
			final JSONArray albums = topLevel.getJSONArray("album");
			for (int i = 0; i < albums.length(); i++)
			{
				final JSONObject album = albums.getJSONObject(i);
				result.add(convertAlbum(album));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
