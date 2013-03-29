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
			final JSONObject topLevel = (JSONObject) response.get("playlists");
			final JSONArray playlists = (JSONArray) topLevel.get("playlist");
			for (int i = 0; i < playlists.length(); i++)
			{
				final JSONObject playlist = playlists.getJSONObject(i);
				result.add(convertPlaylist(playlist));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
