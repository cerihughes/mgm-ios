package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;

public class SpotifyAlbumsForArtistJsonConverter extends SpotifyJsonConverter implements IConverter<JSONObject, Collection<Album>>
{

	@Override
	public Collection<Album> convert(JSONObject response) throws ConverterException
	{
		ArrayList<Album> result = new ArrayList<Album>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("artist");
			final JSONArray albums = (JSONArray) topLevel.get("albums");
			for (int i = 0; i < albums.length(); i++)
			{
				final JSONObject item = albums.getJSONObject(i);
				final JSONObject album = item.getJSONObject("album");
				result.add(convertAlbum(album));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}

	private Album convertAlbum(JSONObject json) throws JSONException
	{
		final Album album = new Album();
		final String href = json.getString("href");
		final String name = json.getString("name");
		final String artist = json.getString("artist");

		album.setId(getIdFromSpotifyHref(href));
		album.setName(name);
		album.setLocation(href);
		album.setArtistName(artist);

		return album;
	}
}
