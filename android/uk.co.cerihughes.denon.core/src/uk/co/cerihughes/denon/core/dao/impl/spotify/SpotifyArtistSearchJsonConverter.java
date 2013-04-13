package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Artist;

public class SpotifyArtistSearchJsonConverter extends SpotifyJsonConverter implements IConverter<JSONObject, List<Artist>>
{

	@Override
	public List<Artist> convert(JSONObject response) throws ConverterException
	{
		ArrayList<Artist> result = new ArrayList<Artist>();
		try
		{
			final JSONArray artists = (JSONArray) response.get("artists");
			for (int i = 0; i < artists.length(); i++)
			{
				JSONObject artist = artists.getJSONObject(i);
				result.add(convertArtist(artist));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}

	private Artist convertArtist(JSONObject json) throws JSONException
	{
		final Artist artist = new Artist();
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
		artist.setId(id);
		artist.setName(name);
		artist.setLocation(href);
		artist.setPopularity(popularityFloat);
		
		artist.putAttribute(SPOTIFY_ARTIST_ID_ATTRIBUTE, id);

		return artist;
	}
}
