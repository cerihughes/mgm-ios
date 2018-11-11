package uk.co.cerihughes.mgm.translate;

import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;
import uk.co.cerihughes.mgm.model.output.OutputAlbum;
import uk.co.cerihughes.mgm.model.output.OutputEvent;
import uk.co.cerihughes.mgm.model.output.OutputLocation;
import uk.co.cerihughes.mgm.model.output.OutputPlaylist;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public abstract class DataTranslation {
    public List<OutputEvent> translate(List<InterimEvent> interimEvents) throws IOException {
        preprocess(interimEvents);

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

        if (classicAlbum.isPresent() && newAlbum.isPresent() == false) {
            return Optional.empty();
        }

        return new OutputEvent.Builder(interimEvent.getNumber(), classicAlbum.get(), newAlbum.get())
                .setDate(interimEvent.getDate())
                .setLocation(translateLocation())
                .setPlaylist(playlist)
                .build();
    }

    private Optional<OutputLocation> translateLocation() {
        final String name = "Crafty Devil's Cellar";
        final double latitude = 51.48227690;
        final double longitude = -3.20186570;

        return new OutputLocation.Builder(name, latitude, longitude)
                .build();
    }

    protected abstract void preprocess(List<InterimEvent> interimEvents) throws IOException;

    protected abstract Optional<OutputAlbum> translate(InterimAlbum interimAlbum);

    protected abstract Optional<OutputPlaylist> translate(InterimPlaylist interimPlaylist);
}

