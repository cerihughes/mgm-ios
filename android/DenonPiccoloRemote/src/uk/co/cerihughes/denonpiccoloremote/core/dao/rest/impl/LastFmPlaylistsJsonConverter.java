package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Playlist;

public class LastFmPlaylistsJsonConverter extends LastFmJsonConverter implements Converter<JSONObject, Collection<Playlist>>
{
	@Override
	public Collection<Playlist> convert(JSONObject response) throws ConvertException
	{
		ArrayList<Playlist> result = new ArrayList<Playlist>();
		try
		{
			JSONObject topLevel = (JSONObject) response.get("playlists");
			JSONArray playlists = (JSONArray) topLevel.get("playlist");
			for (int i = 0; i < playlists.length(); i++)
			{
				JSONObject playlist = playlists.getJSONObject(i);
				result.add(convertPlaylist(playlist));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConvertException(ex);
		}
	}
}
