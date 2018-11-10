package uk.co.cerihughes.mgm.data.input;

import com.google.gson.Gson;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsEntry;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsModel;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class GoogleSheetsDataConverterImpl implements GoogleSheetsDataConverter {
    private Gson gson = new Gson();
    private DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public List<InterimEvent> convert(String json) {
        ArrayList<InterimEvent> events = new ArrayList<>();

        try {
            final GoogleSheetsModel model = deserialise(json);
            final List<GoogleSheetsEntry> entries = model.getFeed().getEntries();
            for (GoogleSheetsEntry entry : entries) {
                events.add(createEvent(entry));
            }
        } catch (NullPointerException e) {
            e.printStackTrace();
            // Swallow
        }

        return events;
    }

    private GoogleSheetsModel deserialise(String json) {
        return gson.fromJson(json, GoogleSheetsModel.class);
    }

    private InterimEvent createEvent(GoogleSheetsEntry entry) {
        final InterimEvent event = new InterimEvent();
        event.setNumber(entry.resolvedId());
        event.setDate(entry.resolvedDate(), formatter);
        event.setClassicAlbum(createClassicAlbum(entry));
        event.setNewAlbum(createNewAlbum(entry));
        event.setPlaylist(createPlaylist(entry));
        return event;
    }

    private InterimAlbum createClassicAlbum(GoogleSheetsEntry entry) {
        final String spotifyId = entry.resolvedClassicSpotifyId();
        if (spotifyId == null) {
            return null;
        }

        final InterimAlbum album = new InterimAlbum();
        album.setType(InterimAlbum.Type.CLASSIC);
        album.setScore(entry.resolvedClassicScore());
        album.setSpotifyID(spotifyId);
        return album;
    }

    private InterimAlbum createNewAlbum(GoogleSheetsEntry entry) {
        final String spotifyId = entry.resolvedNewSpotifyId();
        if (spotifyId == null) {
            return null;
        }

        final InterimAlbum album = new InterimAlbum();
        album.setType(InterimAlbum.Type.NEW);
        album.setScore(entry.resolvedNewScore());
        album.setSpotifyID(spotifyId);
        return album;
    }

    private InterimPlaylist createPlaylist(GoogleSheetsEntry entry) {
        final String spotifyId = entry.resolvedPlaylist();
        if (spotifyId == null) {
            return null;
        }

        final InterimPlaylist playlist = new InterimPlaylist();
        playlist.setSpotifyID(spotifyId);
        return playlist;
    }
}
