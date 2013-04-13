package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;

public class SpotifyAlbumSearchJsonConverter extends SpotifyJsonConverter implements IConverter<JSONObject, List<Album>>
{

	@Override
	public List<Album> convert(JSONObject response) throws ConverterException
	{
		ArrayList<Album> result = new ArrayList<Album>();
		try
		{
			final JSONArray albums = (JSONArray) response.get("albums");
			for (int i = 0; i < albums.length(); i++)
			{
				JSONObject album = albums.getJSONObject(i);
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
		final String popularity = json.getString("popularity");
		Float popularityFloat;
		try
		{
			popularityFloat = Float.parseFloat(popularity);
		}
		catch (NumberFormatException ex)
		{
			popularityFloat = null;
		}

		final String id = getIdFromSpotifyHref(href);
		album.setId(id);
		album.setName(name);
		album.setLocation(href);
		album.setPopularity(popularityFloat);

		final Artist owningArtist = getOwningArtist(json);
		album.setArtistName(owningArtist.getName());

		album.putAttribute(SPOTIFY_ARTIST_ID_ATTRIBUTE, owningArtist.getId());
		album.putAttribute(SPOTIFY_ALBUM_ID_ATTRIBUTE, id);

		return album;
	}
}
