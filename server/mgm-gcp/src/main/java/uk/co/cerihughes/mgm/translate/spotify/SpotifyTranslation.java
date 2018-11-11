package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.model_objects.credentials.ClientCredentials;
import com.wrapper.spotify.model_objects.specification.Album;
import com.wrapper.spotify.model_objects.specification.ArtistSimplified;
import com.wrapper.spotify.model_objects.specification.Playlist;
import com.wrapper.spotify.requests.authorization.client_credentials.ClientCredentialsRequest;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;
import uk.co.cerihughes.mgm.model.output.OutputImages;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;
import uk.co.cerihughes.mgm.translate.DataTranslation;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

public class SpotifyTranslation extends DataTranslation {
    private SpotifyApi spotifyApi = new SpotifyApi.Builder()
            .setClientId(Secrets.clientId)
            .setClientSecret(Secrets.clientSecret)
            .build();

    private GetAlbumsOperation getAlbums = new GetAlbumsOperation();
    private GetPlaylistOperation getPlaylist = new GetPlaylistOperation();

    private Map<String, Album> preprocessedAlbums;

    @Override
    protected void preprocess(List<InterimEvent> interimEvents) throws IOException {
        spotifyApi.setAccessToken(generateAccessToken());

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
        final List<String> albumIds = interimAlbums.stream().map(InterimAlbum::getSpotifyId).collect(Collectors.toList());
        List<Album> albums = getAlbums.execute(spotifyApi, albumIds);
        preprocessedAlbums = albums.stream()
                .collect(Collectors.toMap(Album::getId, Function.identity()));
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
        outputAlbum.setSpotifyId(interimAlbum.getSpotifyId());
        outputAlbum.setName(spotifyAlbum.getName());
        outputAlbum.setArtist(spotifyArtist.getName());
        outputAlbum.setScore(interimAlbum.getScore());
        outputAlbum.setImages(getImages(spotifyAlbum));

        return outputAlbum;
    }

    @Override
    protected OutputPlaylist translate(InterimPlaylist interimPlaylist) {
        return null;
    }

    private OutputImages getImages(Album spotifyAlbum) {
        final OutputImages images = new OutputImages();
        return images;
    }

    private OutputImages getImages(Playlist spotifyPlaylist) {
        final OutputImages images = new OutputImages();
        return images;
    }
}
