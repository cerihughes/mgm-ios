package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Track;

public class SpotifyTrackSearchJsonConverter extends SpotifyJsonConverter implements IConverter<JSONObject, List<Track>>
{

	@Override
	public List<Track> convert(JSONObject response) throws ConverterException
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
		final float popularity = (float) json.getDouble("popularity");
		final int length = json.getInt("length");
		final int number = json.getInt("track-number");

		track.setSource(EDaoType.SPOTIFY_DIRECT);
		final String id = getIdFromSpotifyHref(href);
		track.setId(id);
		track.setName(name);
		track.setLocation(href);
		track.setPopularity(popularity);
		track.setLength(length);
		track.setTrackNumber(number);

		final Artist owningArtist = getOwningArtist(json);
		track.setArtistName(owningArtist.getName());

		final Album owningAlbum = getOwningAlbum(json);
		track.setAlbumName(owningAlbum.getName());

		track.putAttribute(SPOTIFY_ARTIST_ID_ATTRIBUTE, owningArtist.getId());
		track.putAttribute(SPOTIFY_ALBUM_ID_ATTRIBUTE, owningAlbum.getId());
		track.putAttribute(SPOTIFY_TRACK_ID_ATTRIBUTE, id);

		return track;
	}
}
