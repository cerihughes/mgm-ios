package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import uk.co.cerihughes.denon.core.dao.rest.impl.JsonConverter;
import uk.co.cerihughes.denon.core.model.Album;
import uk.co.cerihughes.denon.core.model.Artist;
import uk.co.cerihughes.denon.core.model.Playlist;
import uk.co.cerihughes.denon.core.model.Track;

public abstract class LastFmJsonConverter extends JsonConverter
{

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

	/**
	 * <code>
	 * { "creator" : "http://www.last.fm/user/hughesceri",
          "date" : "2013-03-29T12:08:41",
          "description" : "Playlist 1\n",
          "duration" : "388",
          "id" : "11130446",
          "image" : [ { "#text" : "http://userserve-ak.last.fm/serve/34/88164707.jpg",
                "size" : "small"
              },
              { "#text" : "http://userserve-ak.last.fm/serve/64/88164707.jpg",
                "size" : "medium"
              },
              { "#text" : "http://userserve-ak.last.fm/serve/126/88164707.jpg",
                "size" : "large"
              },
              { "#text" : "http://userserve-ak.last.fm/serve/252/88164707.jpg",
                "size" : "extralarge"
              }
            ],
          "size" : "1",
          "streamable" : "0",
          "title" : "Untitled",
          "url" : "http://www.last.fm/user/hughesceri/library/playlists/6mkb2_"
        }
	 * </code>
	 * 
	 * @param json
	 * @return
	 * @throws JSONException
	 */
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

	/**
	 * <code>
	 * { "image" : [ { "#text" : "http://userserve-ak.last.fm/serve/34/97479.jpg",
                  "size" : "small"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/64/97479.jpg",
                  "size" : "medium"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/126/97479.jpg",
                  "size" : "large"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/252/97479.jpg",
                  "size" : "extralarge"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/500/97479/Sigur+Rs.jpg",
                  "size" : "mega"
                }
              ],
            "mbid" : "f6f2326f-6b25-4170-b89d-e235b25508e8",
            "name" : "Sigur Rós",
            "playcount" : "1591",
            "streamable" : "1",
            "tagcount" : "0",
            "url" : "http://www.last.fm/music/Sigur+R%C3%B3s"
          }
	 * </code>
	 * 
	 * @param json
	 * @return
	 * @throws JSONException
	 */
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

	/**
	 * <code>
	 * { "@attr" : { "releasedate" : "Fri, 22 Mar 2013 00:00:00 +0000" },
            "artist" : { "mbid" : "02f4c1ff-65e0-4412-8e8b-6239b0faecb5",
                "name" : "Phoenix",
                "url" : "http://www.last.fm/music/Phoenix"
              },
            "image" : [ { "#text" : "http://userserve-ak.last.fm/serve/34s/88071561.jpg",
                  "size" : "small"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/64s/88071561.jpg",
                  "size" : "medium"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/126/88071561.jpg",
                  "size" : "large"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/300x300/88071561.jpg",
                  "size" : "extralarge"
                }
              ],
            "mbid" : "",
            "name" : "Love Story",
            "playcount" : "428",
            "tagcount" : "0",
            "url" : "http://www.last.fm/music/Phoenix/Love+Story"
          }
	 * </code>
	 * 
	 * @param json
	 * @return
	 * @throws JSONException
	 */
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

	/**
	 * <code>
	 * { "album" : { "name" : "Go Quiet",
                "position" : ""
              },
            "artist" : { "mbid" : "0ecc2c46-d335-485c-a077-240482609672",
                "name" : "Jónsi",
                "url" : "http://www.last.fm/music/J%C3%B3nsi"
              },
            "duration" : "282000",
            "image" : [ { "#text" : "http://userserve-ak.last.fm/serve/34s/78333758.png",
                  "size" : "small"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/64s/78333758.png",
                  "size" : "medium"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/126/78333758.png",
                  "size" : "large"
                },
                { "#text" : "http://userserve-ak.last.fm/serve/300x300/78333758.png",
                  "size" : "extralarge"
                }
              ],
            "mbid" : "44d749f1-91f6-44b7-9b25-662f6d037d02",
            "name" : "Sinking Friendships",
            "playcount" : "112",
            "streamable" : { "#text" : "1",
                "fulltrack" : "0"
              },
            "tagcount" : "0",
            "url" : "http://www.last.fm/music/J%C3%B3nsi/_/Sinking+Friendships"
          }
	 * </code>
	 * 
	 * @param json
	 * @return
	 * @throws JSONException
	 */
	protected Track convertTrack(JSONObject json) throws JSONException
	{
		final Track track = new Track();
		final String durationString = json.getString("duration");
		Integer duration = null;
		if (durationString != null)
		{
			try
			{
				duration = Integer.parseInt(durationString);
				duration /= 1000;
			}
			catch (NumberFormatException ex)
			{
				duration = null;
			}
		}
		final JSONArray imageArray = json.getJSONArray("image");
		final String imageUri = processImageArray(imageArray);
		final String name = json.getString("name");
		final String url = json.getString("url");

		track.setName(name);
		track.setLength(duration);
		track.setLocation(url);
		track.setImageUri(imageUri);

		return track;
	}

	/**
	 * Process this block:
	 * 
	 * <code>
	 * [
	 *     { "#text" : "http://userserve-ak.last.fm/serve/34/88164707.jpg",
	 *        "size" : "small" },
	 *     { "#text" : "http://userserve-ak.last.fm/serve/64/88164707.jpg",
	 *        "size" : "medium" },
	 *     { "#text" : "http://userserve-ak.last.fm/serve/126/88164707.jpg",
	 *       "size" : "large" },
	 *     { "#text" : "http://userserve-ak.last.fm/serve/252/88164707.jpg",
	 *        "size" : "extralarge" }
	 * ]
	 * </code>
	 * 
	 * @param imageArray
	 * @return
	 * @throws JSONException
	 */
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
}
