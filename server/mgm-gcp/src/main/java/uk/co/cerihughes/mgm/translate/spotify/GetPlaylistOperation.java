package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.model_objects.specification.Playlist;
import com.wrapper.spotify.requests.data.playlists.GetPlaylistRequest;

import java.io.IOException;
import java.util.Optional;

public class GetPlaylistOperation {
    public Optional<Playlist> execute(SpotifyApi spotifyApi, String playlistId) {
        try {
            final GetPlaylistRequest getPlaylistRequest = spotifyApi.getPlaylist(playlistId).build();
            return Optional.ofNullable(getPlaylistRequest.execute());
        } catch (IOException | SpotifyWebApiException e) {
            return Optional.empty();
        }
    }
}