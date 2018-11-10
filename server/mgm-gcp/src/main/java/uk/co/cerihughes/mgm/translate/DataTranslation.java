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
import java.util.stream.Collectors;

public abstract class DataTranslation {
    public List<OutputEvent> translate(List<InterimEvent> interimEvents) throws IOException {
        preprocess(interimEvents);

        return interimEvents.stream()
                .map(e -> translate(e))
                .collect(Collectors.toList());
    }

    private OutputEvent translate(InterimEvent interimEvent) {
        final OutputEvent outputEvent = new OutputEvent();

        outputEvent.setNumber(interimEvent.getNumber());
        outputEvent.setDate(interimEvent.getDate());
        outputEvent.setLocation(translateLocation());

        final InterimAlbum classicAlbum = interimEvent.getClassicAlbum();
        final InterimAlbum newAlbum = interimEvent.getNewAlbum();
        final InterimPlaylist playlist = interimEvent.getPlaylist();

        if (classicAlbum != null) {
            outputEvent.setClassicAlbum(translate(classicAlbum));
        }

        if (newAlbum != null) {
            outputEvent.setNewAlbum(translate(newAlbum));
        }

        if (playlist != null) {
            outputEvent.setPlaylist(translate(playlist));
        }

        return outputEvent;
    }

    private OutputLocation translateLocation() {
        final OutputLocation outputLocation = new OutputLocation();

        outputLocation.setName("Crafty Devil's Cellar");
        outputLocation.setLatitude(51.48227690);
        outputLocation.setLongitude(-3.20186570);

        return outputLocation;
    }

    protected abstract void preprocess(List<InterimEvent> interimEvents) throws IOException;

    protected abstract OutputAlbum translate(InterimAlbum interimAlbum);

    protected abstract OutputPlaylist translate(InterimPlaylist interimPlaylist);
}

