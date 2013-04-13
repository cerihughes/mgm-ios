package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Playlist;

public class LastFmPlaylistsJsonConverter extends LastFmJsonConverter implements IConverter<JSONObject, List<Playlist>>
{
	@Override
	public List<Playlist> convert(JSONObject response) throws ConverterException
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
