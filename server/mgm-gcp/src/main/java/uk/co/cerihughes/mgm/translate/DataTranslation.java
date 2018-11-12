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
import java.util.Objects;
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
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private OutputEvent translate(InterimEvent interimEvent) {
        final OutputAlbum classicAlbum = translate(interimEvent.getClassicAlbum());
        final OutputAlbum newAlbum = translate(interimEvent.getNewAlbum());
        final OutputPlaylist playlist = translate(interimEvent.getPlaylist());

        return new OutputEvent.Builder(interimEvent.getNumber())
                .setDate(interimEvent.getDate())
                .setClassicAlbum(classicAlbum)
                .setNewAlbum(newAlbum)
                .setLocation(translateLocation())
                .setPlaylist(playlist)
                .build();
    }

    private OutputAlbum translate(InterimAlbum interimAlbum) {
        if (interimAlbum == null) {
            return null;
        }

        for (AlbumTranslation albumTranslation : albumTranslations) {
            OutputAlbum outputAlbum = albumTranslation.translate(interimAlbum);
            if (outputAlbum != null) {
                return outputAlbum;
            }
        }

        return null;
    }

    private OutputPlaylist translate(InterimPlaylist interimPlaylist) {
        if (interimPlaylist == null) {
            return null;
        }

        for (PlaylistTranslation playlistTranslation : playlistTranslations) {
            OutputPlaylist outputPlaylist = playlistTranslation.translate(interimPlaylist);
            if (outputPlaylist != null) {
                return outputPlaylist;
            }
        }

        return null;
    }

    private OutputLocation translateLocation() {
        final String name = "Crafty Devil's Cellar";
        final double latitude = 51.48227690;
        final double longitude = -3.20186570;

        return new OutputLocation.Builder()
                .setName(name)
                .setLatitude(latitude)
                .setLongitude(longitude)
                .build();
    }
}

