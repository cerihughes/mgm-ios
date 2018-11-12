package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.model_objects.specification.Playlist;
import com.wrapper.spotify.requests.data.playlists.GetPlaylistRequest;

import java.io.IOException;

public class GetPlaylistOperation {
    public Playlist execute(SpotifyApi spotifyApi, String playlistId) {
        try {
            final GetPlaylistRequest getPlaylistRequest = spotifyApi.getPlaylist(playlistId).build();
            return getPlaylistRequest.execute();
        } catch (IOException | SpotifyWebApiException e) {
            return null;
        }
    }
}