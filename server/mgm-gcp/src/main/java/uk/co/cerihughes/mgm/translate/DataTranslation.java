package uk.co.cerihughes.mgm.translate;

import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;
import uk.co.cerihughes.mgm.model.output.OutputEvent;
import uk.co.cerihughes.mgm.model.output.OutputLocation;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public final class DataTranslation {
    private List<AlbumTranslation> albumTranslations = new ArrayList<>();
    private List<PlaylistTranslation> playlistTranslations = new ArrayList<>();

    public void addAlbumTranslation(AlbumTranslation translation) {
        albumTranslations.add(translation);
    }

    public void addPlaylistTranslation(PlaylistTranslation tranlsation) {
        playlistTranslations.add(tranlsation);
    }

    public List<OutputEvent> translate(List<InterimEvent> interimEvents) {
        Stream.concat(albumTranslations.stream(), playlistTranslations.stream())
                .forEach(e -> e.preprocess(interimEvents));

        return interimEvents.stream()
                .map(e -> translate(e))
                .filter(Optional::isPresent)
                .map(Optional::get)
                .collect(Collectors.toList());
    }

    private Optional<OutputEvent> translate(InterimEvent interimEvent) {
        final Optional<OutputAlbum> classicAlbum = translate(interimEvent.getClassicAlbum());
        final Optional<OutputAlbum> newAlbum = translate(interimEvent.getNewAlbum());
        final Optional<OutputPlaylist> playlist = interimEvent.getPlaylist().flatMap(this::translate);

        return new OutputEvent.Builder(interimEvent.getNumber())
                .setDate(interimEvent.getDate())
                .setClassicAlbum(classicAlbum)
                .setNewAlbum(newAlbum)
                .setLocation(translateLocation())
                .setPlaylist(playlist)
                .build();
    }

    private Optional<OutputAlbum> translate(InterimAlbum interimAlbum) {
        for (AlbumTranslation albumTranslation : albumTranslations) {
            Optional<OutputAlbum> outputAlbum = albumTranslation.translate(interimAlbum);
            if (outputAlbum.isPresent()) {
                return outputAlbum;
            }
        }
        return Optional.empty();
    }

    private Optional<OutputPlaylist> translate(InterimPlaylist interimAlbum) {
        for (PlaylistTranslation playlistTranslation : playlistTranslations) {
            Optional<OutputPlaylist> outputPlaylist = playlistTranslation.translate(interimAlbum);
            if (outputPlaylist.isPresent()) {
                return outputPlaylist;
            }
        }
        return Optional.empty();
    }

    private Optional<OutputLocation> translateLocation() {
        final String name = "Crafty Devil's Cellar";
        final double latitude = 51.48227690;
        final double longitude = -3.20186570;

        return new OutputLocation.Builder(name, latitude, longitude)
                .build();
    }
}

