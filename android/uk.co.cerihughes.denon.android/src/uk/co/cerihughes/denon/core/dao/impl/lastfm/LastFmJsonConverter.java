package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.rest.impl.JsonConverter;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public abstract class LastFmJsonConverter extends JsonConverter
{
	static final String LAST_FM_ARTIST_ID_ATTRIBUTE = "LAST_FM_ARTIST_ID_ATTRIBUTE";
	static final String LAST_FM_TRACK_ID_ATTRIBUTE = "LAST_FM_TRACK_ID_ATTRIBUTE";

	private LastFmImageSize imageSize;

	protected LastFmJsonConverter()
	{
		setImageSize(LastFmImageSize.LARGE);
	}

	public LastFmImageSize getImageSize()
	{
		return imageSize;
	}

	public void setImageSize(LastFmImageSize imageSize)
	{
		this.imageSize = imageSize;
	}

	protected Playlist convertPlaylist(JSONObject json) throws JSONException
	{
		final Playlist playlist = new Playlist();
		final String jsonDate = json.getString("date");
		final Date date = getDate(jsonDate);
		final String description = json.getString("description");
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String title = json.getString("title");
		final String url = json.getString("url");

		playlist.setName(title);
		playlist.setLocation(url);
		playlist.setImageUri(imageUri);
		playlist.setDescription(description);
		playlist.setCreationDate(date);

		return playlist;
	}

	protected Artist convertArtist(JSONObject json) throws JSONException
	{
		final Artist artist = new Artist();
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String name = json.getString("name");
		final String url = json.getString("url");

		artist.setName(name);
		artist.setLocation(url);
		artist.setImageUri(imageUri);

		return artist;
	}

	protected Album convertAlbum(JSONObject json) throws JSONException
	{
		final Album album = new Album();
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String name = json.getString("name");
		final String url = json.getString("url");

		album.setName(name);
		album.setLocation(url);
		album.setImageUri(imageUri);

		return album;
	}

	protected Track convertTrack(JSONObject json) throws JSONException
	{
		final Track track = new Track();
		final String mbid = json.getString("mbid");
		final int duration = json.getInt("duration");
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String name = json.getString("name");
		final String url = json.getString("url");

		track.setId(mbid);
		track.setSource(EDaoType.LAST_FM_DIRECT);
		track.setName(name);
		track.setLength(duration);
		track.setLocation(url);
		track.setImageUri(imageUri);

		final Artist owningArtist = getOwningArtist(json);
		track.setArtistName(owningArtist.getName());
		
		track.putAttribute(LAST_FM_ARTIST_ID_ATTRIBUTE, owningArtist.getId());
		track.putAttribute(LAST_FM_TRACK_ID_ATTRIBUTE, mbid);
		
		return track;
	}

	protected String processImageArray(JSONArray imageArray) throws JSONException
	{
		if (imageArray != null)
		{
			JSONObject lastObject = null;
			for (int i = 0; i < imageArray.length(); i++)
			{
				lastObject = imageArray.getJSONObject(i);
				final String sizeString = lastObject.getString("size");
				if (sizeString != null && sizeString.equals(imageSize.getJsonValue()))
				{
					return getUri(lastObject);
				}
			}
			// If we didn't find the size we were looking for, return the last
			// uri seen (i.e. the largest).
			if (lastObject != null)
			{
				return getUri(lastObject);
			}
		}
		return null;
	}

	private String getUri(JSONObject object) throws JSONException
	{
		final String uri = (String) object.get("#text");
		return uri;
	}
	
	protected Artist getOwningArtist(JSONObject json) throws JSONException
	{
		final Artist artist = new Artist();
		final JSONObject jsonArtist = json.optJSONObject("artist");
		if (artist != null)
		{
			artist.setName(jsonArtist.getString("name"));
			artist.setId(jsonArtist.getString("mbid"));
			artist.setLocation(jsonArtist.getString("url"));
		}
		return artist;
	}
}
