package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Album;

public class LastFmFavouriteAlbumsJsonConverter extends LastFmJsonConverter implements Converter<JSONObject, Collection<Album>>
{

	@Override
	public Collection<Album> convert(JSONObject response) throws ConvertException
	{
		ArrayList<Album> result = new ArrayList<Album>();
		try
		{
			JSONObject topLevel = (JSONObject) response.get("albums");
			JSONArray albums = (JSONArray) topLevel.get("album");
			for (int i = 0; i < albums.length(); i++)
			{
				JSONObject album = albums.getJSONObject(i);
				result.add(convertAlbum(album));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConvertException(ex);
		}
	}
}
