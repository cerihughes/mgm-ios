package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;

public class LastFmFavouriteAlbumsJsonConverter extends LastFmJsonConverter implements IConverter<JSONObject, List<Album>>
{

	@Override
	public List<Album> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Album> result = new ArrayList<Album>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("topalbums");
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
