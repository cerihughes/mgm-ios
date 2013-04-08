package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public class SpotifyTrackSearchJsonConverter extends SpotifyJsonConverter implements IConverter<JSONObject, Collection<Track>>
{

	@Override
	public Collection<Track> convert(JSONObject response) throws ConverterException
	{
		ArrayList<Track> result = new ArrayList<Track>();
		try
		{
			final JSONArray tracks = (JSONArray) response.get("tracks");
			for (int i = 0; i < tracks.length(); i++)
			{
				JSONObject track = tracks.getJSONObject(i);
				result.add(convertTrack(track));
			}
			return result;
		}
		catch (JSONException ex)
		{
			throw new ConverterException(ex);
		}
	}

	private Track convertTrack(JSONObject json) throws JSONException
	{
		final Track track = new Track();
		final String href = json.getString("href");
		final String name = json.getString("name");
		final String popularity = json.getString("popularity");
		final int length = json.getInt("length");

		Float popularityFloat;
		try
		{
			popularityFloat = Float.parseFloat(popularity);
		}
		catch (NumberFormatException ex)
		{
			popularityFloat = null;
		}

		track.setId(getIdFromSpotifyHref(href));
		track.setName(name);
		track.setLocation(href);
		track.setPopularity(popularityFloat);
		track.setLength(length);

		final Artist owningArtist = getOwningArtist(json);
		track.setArtistName(owningArtist.getName());

		final Album owningAlbum = getOwningAlbum(json);
		track.setAlbumName(owningAlbum.getName());

		return track;
	}
}
