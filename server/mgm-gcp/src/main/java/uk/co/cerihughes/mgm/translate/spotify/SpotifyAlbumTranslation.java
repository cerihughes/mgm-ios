package uk.co.cerihughes.mgm.translate.spotify;

import com.wrapper.spotify.SpotifyApi;
import com.wrapper.spotify.model_objects.specification.Album;
import com.wrapper.spotify.model_objects.specification.ArtistSimplified;
import uk.co.cerihughes.mgm.model.AlbumType;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;
import uk.co.cerihughes.mgm.translate.AlbumTranslation;

import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public final class SpotifyAlbumTranslation extends SpotifyTranslation implements AlbumTranslation {
    private SpotifyApi spotifyApi;

    private GetAlbumsOperation getAlbumsOperation = new GetAlbumsOperation();
    private Map<String, Album> preprocessedAlbums = new HashMap<>();

    public SpotifyAlbumTranslation(SpotifyApi spotifyApi) {
        super();

        this.spotifyApi = spotifyApi;
    }

    @Override
    public void preprocess(List<InterimEvent> interimEvents) {
        if (interimEvents == null || interimEvents.size() == 0) {
            return;
        }

        preprocessAlbums(interimEvents);
    }

    protected void preprocessAlbums(List<InterimEvent> interimEvents) {
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
                .map(InterimAlbum::getAlbumData)
                .filter(s -> isValidData(s))
                .collect(Collectors.toList());
        final List<Album> albums = getAlbumsOperation.execute(spotifyApi, albumIds);
        preprocessedAlbums = albums.stream()
                .collect(Collectors.toMap(Album::getId, Function.identity()));
    }

    @Override
    public Optional<OutputAlbum> translate(InterimAlbum interimAlbum) {
        final String spotifyId = interimAlbum.getAlbumData();
        if (isValidData(spotifyId) == false) {
            return Optional.empty();
        }

        final AlbumType type = interimAlbum.getType();
        if (type == null || spotifyId == null) {
            return Optional.empty();
        }

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

        return new OutputAlbum.Builder(type, name, artist)
                .setSpotifyId(spotifyId)
                .setScore(interimAlbum.getScore())
                .setImages(getImages(spotifyAlbum.getImages()))
                .build();
    }
}