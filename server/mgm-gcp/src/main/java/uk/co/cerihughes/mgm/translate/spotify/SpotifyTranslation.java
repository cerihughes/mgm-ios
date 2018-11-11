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
        final List<String> albumIds = interimAlbums.stream().map(InterimAlbum::getSpotifyId)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
        List<Album> albums = getAlbums.execute(spotifyApi, albumIds);
        preprocessedAlbums = albums.stream()
                .collect(Collectors.toMap(Album::getId, Function.identity()));
    }

    protected void preprocessPlaylists(List<InterimEvent> interimEvents) throws IOException {
        final List<String> playlistIds = interimEvents.stream()
                .map(InterimEvent::getPlaylist)
                .filter(Objects::nonNull)
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
    protected OutputAlbum translate(InterimAlbum interimAlbum) {
        final OutputAlbum outputAlbum = new OutputAlbum();
        final String spotifyId = interimAlbum.getSpotifyId();

        final Album spotifyAlbum = preprocessedAlbums.get(spotifyId);
        if (spotifyAlbum == null) {
            return outputAlbum;
        }

        final ArtistSimplified[] spotifyArtists = spotifyAlbum.getArtists();
        if (spotifyArtists == null || spotifyArtists.length == 0) {
            return outputAlbum;
        }

        final ArtistSimplified spotifyArtist = spotifyArtists[0];

        outputAlbum.setType(interimAlbum.getType());
        outputAlbum.setSpotifyId(spotifyId);
        outputAlbum.setName(spotifyAlbum.getName());
        outputAlbum.setArtist(spotifyArtist.getName());
        outputAlbum.setScore(interimAlbum.getScore());
        outputAlbum.setImages(getImages(spotifyAlbum.getImages()));

        return outputAlbum;
    }

    @Override
    protected OutputPlaylist translate(InterimPlaylist interimPlaylist) {
        final OutputPlaylist outputPlaylist = new OutputPlaylist();
        final String spotifyId = interimPlaylist.getSpotifyId();

        final Playlist spotifyPlaylist = preprocessedPlaylists.get(spotifyId);
        if (spotifyPlaylist == null) {
            return outputPlaylist;
        }

        final User spotifyUser = spotifyPlaylist.getOwner();

        outputPlaylist.setSpotifyId(spotifyId);
        outputPlaylist.setName(spotifyPlaylist.getName());
        outputPlaylist.setOwner(spotifyUser != null ? spotifyUser.getDisplayName() : null);
        outputPlaylist.setImages(getImages(spotifyPlaylist.getImages()));

        return outputPlaylist;
    }

    private List<OutputImage> getImages(Image[] spotifyImages) {
        if (spotifyImages == null || spotifyImages.length == 0) {
            return null;
        }

        return Arrays.stream(spotifyImages).map(i -> createOutputImage(i))
                .filter(Objects::nonNull)
                .sorted((o1, o2) -> new Integer(o1.getSize()).compareTo(new Integer(o2.getSize())))
                .collect(Collectors.toList());
    }

    private OutputImage createOutputImage(Image spotifyImage) {
        final Integer width = spotifyImage.getWidth();
        final Integer height = spotifyImage.getHeight();
        final String url = spotifyImage.getUrl();
        if ((width == null || height == null) || url == null) {
            return null;
        }

        int w = width == null ? 0 : width;
        int h = height == null ? 0 : height;

        final OutputImage outputImage = new OutputImage();
        outputImage.setSize(Math.max(width, height));
        outputImage.setUrl(url);
        return outputImage;
    }
}
