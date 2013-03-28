package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

import java.util.ArrayList;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.ConvertException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.rest.Converter;
import uk.co.cerihughes.denonpiccoloremote.core.model.Artist;

public class SpotifyArtistSearchJsonConverter implements
		Converter<JSONObject, Collection<Artist>> {

	@Override
	public Collection<Artist> convert(JSONObject response)
			throws ConvertException {
		ArrayList<Artist> result = new ArrayList<Artist>();
		try {
			JSONObject info = (JSONObject) response.get("info");
			JSONArray artists = (JSONArray) response.get("artists");
			for (int i = 0; i < artists.length(); i++) {
				JSONObject artist = artists.getJSONObject(i);
				result.add(convertArtist(artist));
			}
			return result;
		} catch (JSONException ex) {
			throw new ConvertException(ex);
		}
	}

	private Artist convertArtist(JSONObject json) throws JSONException {
		Artist artist = new Artist();
		String href = (String) json.get("href");
		String name = (String) json.get("name");
		String popularity = (String) json.get("popularity");
		Float popularityFloat;
		try {
			popularityFloat = Float.parseFloat(popularity);
		} catch (NumberFormatException ex) {
			popularityFloat = null;
		}

		artist.setName(name);
		artist.setLocation(href);
		artist.setPopularity(popularityFloat);

		return artist;
	}
}
