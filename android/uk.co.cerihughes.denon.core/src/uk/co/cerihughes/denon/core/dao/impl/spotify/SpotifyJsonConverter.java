package uk.co.cerihughes.denon.core.dao.impl.spotify;

import org.json.JSONArray;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.rest.impl.JsonConverter;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;

public abstract class SpotifyJsonConverter extends JsonConverter
{
	static final String SPOTIFY_ARTIST_ID_ATTRIBUTE = "SPOTIFY_ARTIST_ID_ATTRIBUTE";
	static final String SPOTIFY_ALBUM_ID_ATTRIBUTE = "SPOTIFY_ALBUM_ID_ATTRIBUTE";
	static final String SPOTIFY_TRACK_ID_ATTRIBUTE = "SPOTIFY_TRACK_ID_ATTRIBUTE";
	
	protected String getIdFromSpotifyHref(String href)
	{
		if (href != null)
		{
			final String[] splits = href.split(":");
			if (splits.length == 3)
			{
				return splits[2];
			}
		}
		return null;
	}

	protected Artist getOwningArtist(JSONObject json)
	{
		final Artist artist = new Artist();
		final JSONArray artists = json.getJSONArray("artists");
		if (artists.length() > 0)
		{
			final JSONObject jsonArtist = artists.getJSONObject(0);
			final String href = jsonArtist.getString("href");
			artist.setId(getIdFromSpotifyHref(href));
			artist.setName(jsonArtist.getString("name"));
		}
		return artist;
	}

	protected Album getOwningAlbum(JSONObject json)
	{
		final Album album = new Album();
		final JSONObject jsonAlbum = json.getJSONObject("album");
		final String href = jsonAlbum.getString("href");
		album.setId(getIdFromSpotifyHref(href));
		album.setName(jsonAlbum.getString("name"));
		return album;
	}
}
