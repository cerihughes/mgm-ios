package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Track;

public class LastFmFavouriteTracksJsonConverter extends LastFmJsonConverter implements IConverter<JSONObject, List<Track>>
{
	@Override
	public List<Track> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Track> result = new ArrayList<Track>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("tracks");
			final JSONArray tracks = topLevel.getJSONArray("track");
			for (int i = 0; i < tracks.length(); i++)
			{
				final JSONObject track = tracks.getJSONObject(i);
				result.add(convertTrack(track));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
