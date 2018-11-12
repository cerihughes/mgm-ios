package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.model_objects.specification.Playlist;
import com.wrapper.spotify.model_objects.specification.User;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;
import uk.co.cerihughes.mgm.translate.PlaylistTranslation;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

public final class SpotifyPlaylistTranslation extends SpotifyTranslation implements PlaylistTranslation {
    private SpotifyApi spotifyApi;

    private GetPlaylistOperation getPlaylistOperation = new GetPlaylistOperation();
    private Map<String, Playlist> preprocessedPlaylists = new HashMap<>();

    public SpotifyPlaylistTranslation(SpotifyApi spotifyApi) {
        super();

        this.spotifyApi = spotifyApi;
    }

    @Override
    public void preprocess(List<InterimEvent> interimEvents) {
        if (interimEvents == null || interimEvents.size() == 0) {
            return;
        }

        preprocessPlaylists(interimEvents);
    }

    protected void preprocessPlaylists(List<InterimEvent> interimEvents) {
        final List<String> playlistIds = interimEvents.stream()
                .map(InterimEvent::getPlaylist)
                .filter(Objects::nonNull)
                .map(InterimPlaylist::getPlaylistData)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        if (playlistIds.isEmpty()) {
            return;
        }

        // For now, just process the last playlist as the app only renders the most recent event.
        // The Spotify web API currently doesn't support batch gets on a playlist, so this saves unnecessary network
        // calls too.
        final String playlistId = playlistIds.get(playlistIds.size() - 1);
        Playlist playlist = getPlaylistOperation.execute(spotifyApi, playlistId);
        if (playlist != null) {
            preprocessedPlaylists.put(playlistId, playlist);
        }
    }

    @Override
    public OutputPlaylist translate(InterimPlaylist interimPlaylist) {
        final String spotifyId = interimPlaylist.getPlaylistData();
        if (isValidData(spotifyId) == false) {
            return null;
        }

        final Playlist spotifyPlaylist = preprocessedPlaylists.get(spotifyId);
        if (spotifyPlaylist == null) {
            return null;
        }

        final User spotifyUser = spotifyPlaylist.getOwner();
        if (spotifyUser == null) {
            return null;
        }

        final String name = spotifyPlaylist.getName();
        final String owner = spotifyUser.getDisplayName();
        return new OutputPlaylist.Builder()
                .setSpotifyId(spotifyId)
                .setName(name)
                .setOwner(owner)
                .setImages(getImages(spotifyPlaylist.getImages()))
                .build();
    }
}