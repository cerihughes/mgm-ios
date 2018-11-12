package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.model_objects.specification.Playlist;
import com.wrapper.spotify.model_objects.specification.User;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;
import uk.co.cerihughes.mgm.translate.PlaylistTranslation;

import java.util.*;
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
                .filter(Optional::isPresent)
                .map(Optional::get)
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
        Optional<Playlist> playlist = getPlaylistOperation.execute(spotifyApi, playlistId);
        if (playlist.isPresent()) {
            preprocessedPlaylists.put(playlistId, playlist.get());
        }
    }

    @Override
    public Optional<OutputPlaylist> translate(InterimPlaylist interimPlaylist) {
        final String spotifyId = interimPlaylist.getPlaylistData();
        if (isValidData(spotifyId) == false) {
            return Optional.empty();
        }

        final Playlist spotifyPlaylist = preprocessedPlaylists.get(spotifyId);
        if (spotifyPlaylist == null) {
            return Optional.empty();
        }

        final User spotifyUser = spotifyPlaylist.getOwner();
        if (spotifyUser == null) {
            return Optional.empty();
        }

        final String name = spotifyPlaylist.getName();
        final String owner = spotifyUser.getDisplayName();
        if (name == null || owner == null) {
            return Optional.empty();
        }

        return new OutputPlaylist.Builder(spotifyId, name, owner)
                .setImages(getImages(spotifyPlaylist.getImages()))
                .build();
    }
}