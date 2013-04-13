package uk.co.cerihughes.denon.core.dao.impl.spotify;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;
import uk.co.cerihughes.denon.core.model.Track;

public class SpotifyTracksForAlbumJsonConverter extends SpotifyJsonConverter implements IConverter<JSONObject, List<Track>>
{
	@Override
	public List<Track> convert(JSONObject response) throws ConverterException
	{
		final ArrayList<Track> result = new ArrayList<Track>();
		try
		{
			final JSONObject topLevel = response.getJSONObject("album");
			final String albumName = topLevel.getString("name");
			final String albumHref = topLevel.getString("href");
			final String albumId = getIdFromSpotifyHref(albumHref);
			final String artistName = topLevel.optString("artist");
			final String artistHref = topLevel.optString("artist-id");
			String artistId = null;
			if (artistHref != null)
			{
				artistId = getIdFromSpotifyHref(artistHref);
			}
			final JSONArray tracks = (JSONArray) topLevel.get("tracks");
			for (int i = 0; i < tracks.length(); i++)
			{
				final JSONObject jsonTrack = tracks.getJSONObject(i);
				final Track track = convertTrack(jsonTrack);
				track.setArtistName(artistName);
				track.setAlbumName(albumName);
				track.putAttribute(SPOTIFY_ARTIST_ID_ATTRIBUTE, artistId);
				track.putAttribute(SPOTIFY_ALBUM_ID_ATTRIBUTE, albumId);
				result.add(track);
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
		final int trackNumber = json.getInt("track-number");
		final int discNumber = json.getInt("disc-number");
		final int length = json.getInt("length");
		final float popularity = (float) json.getDouble("popularity");

		track.setSource(EDaoType.SPOTIFY_DIRECT);
		final String id = getIdFromSpotifyHref(href);
		track.setId(id);
		track.setName(name);
		track.setLocation(href);
		track.setTrackNumber(trackNumber);
		track.setDiscNumber(discNumber);
		track.setLength(length);
		track.setPopularity(popularity);

		track.putAttribute(SPOTIFY_TRACK_ID_ATTRIBUTE, id);

		return track;
	}
}
