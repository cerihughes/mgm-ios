package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.exceptions.SpotifyWebApiException;
import com.wrapper.spotify.model_objects.credentials.ClientCredentials;
import com.wrapper.spotify.requests.authorization.client_credentials.ClientCredentialsRequest;
import uk.co.cerihughes.mgm.translate.AlbumTranslation;
import uk.co.cerihughes.mgm.translate.PlaylistTranslation;

import java.io.IOException;

public class SpotifyTranslationFactory {
    private static SpotifyApi spotifyApi = new SpotifyApi.Builder()
            .setClientId(Secrets.clientId)
            .setClientSecret(Secrets.clientSecret)
            .build();

    public void generateToken() throws IOException {
        final String accessToken = generateAccessToken(spotifyApi);
        spotifyApi.setAccessToken(accessToken);
    }

    public AlbumTranslation createAlbumTranslation() {
        return new SpotifyAlbumTranslation(spotifyApi);
    }

    public PlaylistTranslation createPlaylistTranslation() {
        return new SpotifyPlaylistTranslation(spotifyApi);
    }

    private String generateAccessToken(SpotifyApi spotifyApi) throws IOException {
        final ClientCredentialsRequest clientCredentialsRequest = spotifyApi.clientCredentials().build();
        try {
            final ClientCredentials clientCredentials = clientCredentialsRequest.execute();
            return clientCredentials.getAccessToken();
        } catch (SpotifyWebApiException e) {
            throw new IOException(e);
        }
    }
}