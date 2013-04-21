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
			final JSONArray playlistsArray = topLevel.optJSONArray("playlist");
			if (playlistsArray != null)
			{
				for (int i = 0; i < playlistsArray.length(); i++)
				{
					final JSONObject playlist = playlistsArray.getJSONObject(i);
					result.add(convertPlaylist(playlist));
				}
			}
			else
			{
				final JSONObject playlistObject = topLevel.optJSONObject("playlist");
				if (playlistObject != null)
				{
					result.add(convertPlaylist(playlistObject));
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
