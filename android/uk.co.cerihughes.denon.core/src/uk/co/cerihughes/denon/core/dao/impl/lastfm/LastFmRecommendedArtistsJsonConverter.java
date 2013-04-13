package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Artist;

public class LastFmRecommendedArtistsJsonConverter extends LastFmFavouriteArtistsJsonConverter
{
	@Override
	public List<Artist> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Artist> result = new ArrayList<Artist>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("recommendations");
			final JSONArray artists = topLevel.getJSONArray("artist");
			for (int i = 0; i < artists.length(); i++)
			{
				final JSONObject artist = artists.getJSONObject(i);
				result.add(convertArtist(artist));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
