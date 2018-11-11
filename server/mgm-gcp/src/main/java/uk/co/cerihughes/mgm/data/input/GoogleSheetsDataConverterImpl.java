package uk.co.cerihughes.mgm.data.input;

import com.google.gson.Gson;
import uk.co.cerihughes.mgm.data.DateTimeFormatterFactory;
import uk.co.cerihughes.mgm.model.AlbumType;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsEntry;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsFeed;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsModel;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.function.Supplier;

public class GoogleSheetsDataConverterImpl implements GoogleSheetsDataConverter {
    private Gson gson = new Gson();
    private DateTimeFormatter formatter = DateTimeFormatterFactory.formatter;

    public List<InterimEvent> convert(String json) {
        ArrayList<InterimEvent> events = new ArrayList<>();

        final GoogleSheetsModel model = deserialise(json);
        final Optional<GoogleSheetsFeed> feed = model.getFeed();
        if (feed.isPresent()) {
            final List<GoogleSheetsEntry> entries = model.getFeed().get().resolvedEntries();
            for (GoogleSheetsEntry entry : entries) {
                try {
                    events.add(createEvent(entry));
                } catch (MissingRequiredDataException e) {
                    // Swallow
                }
            }
        }

        return events;
    }

    private GoogleSheetsModel deserialise(String json) {
        return gson.fromJson(json, GoogleSheetsModel.class);
    }

    private InterimEvent createEvent(GoogleSheetsEntry entry) throws MissingRequiredDataException {
        final String numberString = entry.resolvedId().orElseThrow(exception("Missing event ID"));
        final InterimAlbum classicAlbum = createClassicAlbum(entry).orElseThrow(exception("Missing classic album"));
        final InterimAlbum newAlbum = createNewAlbum(entry).orElseThrow(exception("Missing new album"));

        try {
            int number = new Integer(numberString);
            return new InterimEvent.Builder(number, classicAlbum, newAlbum)
                    .setDateString(entry.resolvedDate(), formatter)
                    .setPlaylist(createPlaylist(entry))
                    .build()
                    .orElseThrow(exception("Missing event data"));
        } catch (NumberFormatException e) {
            throw new MissingRequiredDataException(e);
        }
    }

    private Supplier<MissingRequiredDataException> exception(String message) {
        return () -> new MissingRequiredDataException(message);
    }

    private Optional<InterimAlbum> createClassicAlbum(GoogleSheetsEntry entry) throws MissingRequiredDataException {
        return createAlbum(AlbumType.NEW,
                entry.resolvedClassicScore(),
                entry.resolvedClassicSpotifyId().orElseThrow(exception("Missing Spotify ID")));
    }

    private Optional<InterimAlbum> createNewAlbum(GoogleSheetsEntry entry) throws MissingRequiredDataException {
        return createAlbum(AlbumType.NEW,
                entry.resolvedNewScore(),
                entry.resolvedNewSpotifyId().orElseThrow(exception("Missing Spotify ID")));
    }

    private Optional<InterimAlbum> createAlbum(AlbumType type, Optional<String> score, String spotifyId) {
        return new InterimAlbum.Builder(type, spotifyId)
                .setScoreString(score)
                .build();
    }

    private Optional<InterimPlaylist> createPlaylist(GoogleSheetsEntry entry) {
        return entry.resolvedPlaylist().flatMap(value -> new InterimPlaylist.Builder(value).build());
    }
}
