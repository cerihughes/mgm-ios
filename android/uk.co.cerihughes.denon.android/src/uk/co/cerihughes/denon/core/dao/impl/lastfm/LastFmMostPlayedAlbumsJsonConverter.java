package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;

public class LastFmMostPlayedAlbumsJsonConverter extends LastFmJsonConverter implements IConverter<JSONObject, List<Album>>
{

	@Override
	public List<Album> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Album> result = new ArrayList<Album>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("topalbums");
			final JSONArray albumsArray = topLevel.optJSONArray("album");
			if (albumsArray != null)
			{
				for (int i = 0; i < albumsArray.length(); i++)
				{
					final JSONObject album = albumsArray.getJSONObject(i);
					result.add(convertAlbum(album));
				}
			}
			else
			{
				final JSONObject albumsObject = topLevel.optJSONObject("album");
				if (albumsObject != null)
				{
					result.add(convertAlbum(albumsObject));
				}
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
