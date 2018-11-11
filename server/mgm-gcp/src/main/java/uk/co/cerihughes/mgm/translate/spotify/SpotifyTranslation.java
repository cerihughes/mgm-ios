package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.model_objects.credentials.ClientCredentials;
import com.wrapper.spotify.model_objects.specification.*;
import com.wrapper.spotify.requests.authorization.client_credentials.ClientCredentialsRequest;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;
import uk.co.cerihughes.mgm.model.output.OutputImage;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;
import uk.co.cerihughes.mgm.translate.DataTranslation;

import java.io.IOException;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public class SpotifyTranslation extends DataTranslation {
    private SpotifyApi spotifyApi = new SpotifyApi.Builder()
            .setClientId(Secrets.clientId)
            .setClientSecret(Secrets.clientSecret)
            .build();

    private GetAlbumsOperation getAlbums = new GetAlbumsOperation();
    private GetPlaylistOperation getPlaylist = new GetPlaylistOperation();

    private Map<String, Album> preprocessedAlbums = new HashMap<>();
    private Map<String, Playlist> preprocessedPlaylists = new HashMap<>();

    @Override
    protected void preprocess(List<InterimEvent> interimEvents) throws IOException {
        if (interimEvents == null || interimEvents.size() == 0) {
            return;
        }

        spotifyApi.setAccessToken(generateAccessToken());

        preprocessAlbums(interimEvents);
        preprocessPlaylists(interimEvents);
    }

    protected void preprocessAlbums(List<InterimEvent> interimEvents) throws IOException {
        final ArrayList<InterimAlbum> interimAlbums = new ArrayList<>();
        for (InterimEvent interimEvent : interimEvents) {
            InterimAlbum classicAlbum = interimEvent.getClassicAlbum();
            InterimAlbum newAlbum = interimEvent.getNewAlbum();
            if (classicAlbum != null) {
                interimAlbums.add(classicAlbum);
            }
            if (newAlbum != null) {
                interimAlbums.add(newAlbum);
            }

        }
        final List<String> albumIds = interimAlbums.stream()
                .map(InterimAlbum::getSpotifyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        List<Album> albums = getAlbums.execute(spotifyApi, albumIds);
        preprocessedAlbums = albums.stream()
                .collect(Collectors.toMap(Album::getId, Function.identity()));
    }

    protected void preprocessPlaylists(List<InterimEvent> interimEvents) throws IOException {
        final List<String> playlistIds = interimEvents.stream()
                .map(InterimEvent::getPlaylist)
                .filter(Optional::isPresent)
                .map(Optional::get)
                .map(InterimPlaylist::getSpotifyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());

        if (playlistIds.isEmpty()) {
            return;
        }

        // For now, just process the last playlist as the app only renders the most recent event.
        // The Spotify web API currently doesn't support batch gets on a playlist, so this saves unnecessary network
        // calls too.
        final String playlistId = playlistIds.get(playlistIds.size() - 1);
        Playlist playlist = getPlaylist.execute(spotifyApi, playlistId);
        if (playlist != null) {
            preprocessedPlaylists.put(playlistId, playlist);
        }
    }

    private String generateAccessToken() throws IOException {
        final ClientCredentialsRequest clientCredentialsRequest = spotifyApi.clientCredentials().build();
        try {
            final ClientCredentials clientCredentials = clientCredentialsRequest.execute();
            return clientCredentials.getAccessToken();
        } catch (SpotifyWebApiException e) {
            throw new IOException(e);
        }
    }

    @Override
    protected Optional<OutputAlbum> translate(InterimAlbum interimAlbum) {
        final String spotifyId = interimAlbum.getSpotifyId();

        final Album spotifyAlbum = preprocessedAlbums.get(spotifyId);
        if (spotifyAlbum == null) {
            return Optional.empty();
        }

        final ArtistSimplified[] spotifyArtists = spotifyAlbum.getArtists();
        if (spotifyArtists == null || spotifyArtists.length == 0) {
            return Optional.empty();
        }

        final ArtistSimplified spotifyArtist = spotifyArtists[0];
        final String name = spotifyAlbum.getName();
        final String artist = spotifyArtist.getName();
        if (name == null || artist == null) {
            return Optional.empty();
        }

        return new OutputAlbum.Builder(spotifyId, name, artist)
                .setScore(interimAlbum.getScore())
                .setImages(getImages(spotifyAlbum.getImages()))
                .build();
    }

    @Override
    protected Optional<OutputPlaylist> translate(InterimPlaylist interimPlaylist) {
        final String spotifyId = interimPlaylist.getSpotifyId();

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

    private Optional<List<OutputImage>> getImages(Image[] spotifyImages) {
        if (spotifyImages == null || spotifyImages.length == 0) {
            return Optional.empty();
        }

        final List<OutputImage> outputImages = Arrays.stream(spotifyImages)
                .map(i -> createOutputImage(i))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList());
        return Optional.of(outputImages);
    }

    private Optional<OutputImage> createOutputImage(Image spotifyImage) {
        final Integer width = spotifyImage.getWidth();
        final Integer height = spotifyImage.getHeight();
        final String url = spotifyImage.getUrl();
        if ((width == null || height == null) || url == null) {
            return Optional.empty();
        }

        int w = width == null ? 0 : width;
        int h = height == null ? 0 : height;
        int size = Math.max(w, h);

        return new OutputImage.Builder(size, url).build();
    }
}