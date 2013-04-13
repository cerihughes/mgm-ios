package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;

public class SpotifyAlbumsForArtistJsonConverter extends SpotifyJsonConverter implements IConverter<JSONObject, List<Album>>
{

	@Override
	public List<Album> convert(JSONObject response) throws ConverterException
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

		final String id = getIdFromSpotifyHref(href);
		album.setId(id);
		album.setName(name);
		album.setLocation(href);
		album.setArtistName(artist);

		final String artistHref = json.optString("artist-id");
		if (artistHref != null)
		{
			final String artistId = getIdFromSpotifyHref(artistHref);
			album.putAttribute(SPOTIFY_ARTIST_ID_ATTRIBUTE, artistId);
		}
		album.putAttribute(SPOTIFY_ALBUM_ID_ATTRIBUTE, id);

		return album;
	}
}
