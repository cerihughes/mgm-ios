package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConverterException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;

public class LastFmPlaylistsJsonConverter extends LastFmJsonConverter implements Converter<JSONObject, Collection<Playlist>>
{
	@Override
	public Collection<Playlist> convert(JSONObject response) throws ConverterException
	{
		ArrayList<Playlist> result = new ArrayList<Playlist>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("playlists");
			final Object next = topLevel.get("playlist");
			if (next instanceof JSONObject)
			{
				final JSONObject playlist = (JSONObject) next;
				result.add(convertPlaylist(playlist));
			}
			else if (next instanceof JSONArray)
			{
				final JSONArray playlists = (JSONArray) next;
				for (int i = 0; i < playlists.length(); i++)
				{
					final JSONObject playlist = playlists.getJSONObject(i);
					result.add(convertPlaylist(playlist));
				}
			}					
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
		return result;
	}
}
