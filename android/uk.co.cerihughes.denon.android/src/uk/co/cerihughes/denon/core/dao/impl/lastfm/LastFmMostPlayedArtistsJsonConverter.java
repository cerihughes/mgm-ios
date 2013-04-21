package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Artist;

public class LastFmMostPlayedArtistsJsonConverter extends LastFmJsonConverter implements IConverter<JSONObject, List<Artist>>
{

	@Override
	public List<Artist> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Artist> result = new ArrayList<Artist>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("topartists");
			final JSONArray artistsArray = topLevel.optJSONArray("artist");
			if (artistsArray != null)
			{
				for (int i = 0; i < artistsArray.length(); i++)
				{
					final JSONObject artist = artistsArray.getJSONObject(i);
					result.add(convertArtist(artist));
				}
			}
			else
			{
				final JSONObject albumsObject = topLevel.optJSONObject("artist");
				if (albumsObject != null)
				{
					result.add(convertArtist(albumsObject));
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
