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
	static final String LAST_FM_ALBUM_ID_ATTRIBUTE = "LAST_FM_ALBUM_ID_ATTRIBUTE";
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

	private String getMbid(JSONObject json) throws JSONException
	{
		final String mbid = json.optString("mbid");
		if (mbid != null && mbid.length() > 0)
		{
			return mbid;
		}
		return null;
	}

	protected Playlist convertPlaylist(JSONObject json) throws JSONException
	{
		final Playlist playlist = new Playlist();
		final String id = json.getString("id");
		final String jsonDate = json.getString("date");
		final Date date = getDate(jsonDate);
		final String description = json.getString("description");
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String title = json.getString("title");
		final String url = json.getString("url");
		final int trackCount = json.getInt("size");

		playlist.setId(id);
		playlist.setSource(EDaoType.LAST_FM_DIRECT);
		playlist.setName(title);
		playlist.setUri(url);
		playlist.setImageUri(imageUri);
		playlist.setDescription(description);
		playlist.setCreationDate(date);
		playlist.setTrackCount(trackCount);

		return playlist;
	}

	protected Artist convertArtist(JSONObject json) throws JSONException
	{
		final Artist artist = new Artist();
		final String mbid = getMbid(json);
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String name = json.getString("name");
		final String url = json.getString("url");

		artist.setId(mbid);
		artist.setSource(EDaoType.LAST_FM_DIRECT);
		artist.setName(name);
		artist.setUri(url);
		artist.setImageUri(imageUri);

		artist.putAttribute(LAST_FM_ARTIST_ID_ATTRIBUTE, mbid);

		return artist;
	}

	protected Album convertAlbum(JSONObject json) throws JSONException
	{
		final Album album = new Album();
		final String mbid = getMbid(json);
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String name = json.getString("name");
		final String url = json.getString("url");

		album.setId(mbid);
		album.setSource(EDaoType.LAST_FM_DIRECT);
		album.setName(name);
		album.setUri(url);
		album.setImageUri(imageUri);

		final Artist owningArtist = getOwningArtist(json);
		album.setArtistName(owningArtist.getName());

		album.putAttribute(LAST_FM_ARTIST_ID_ATTRIBUTE, owningArtist.getId());
		album.putAttribute(LAST_FM_ALBUM_ID_ATTRIBUTE, mbid);

		return album;
	}

	protected Track convertTrack(JSONObject json) throws JSONException
	{
		final Track track = new Track();
		final String mbid = getMbid(json);
		Integer duration = json.optInt("duration", -1);
		if (duration == -1)
		{
			duration = null;
		}
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String name = json.getString("name");
		final String url = json.getString("url");

		track.setId(mbid);
		track.setSource(EDaoType.LAST_FM_DIRECT);
		track.setName(name);
		track.setLength(duration);
		track.setUri(url);
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
			final String mbid = getMbid(jsonArtist);
			artist.setName(jsonArtist.getString("name"));
			artist.setId(mbid);
			artist.setUri(jsonArtist.getString("url"));
		}
		return artist;
	}
}
