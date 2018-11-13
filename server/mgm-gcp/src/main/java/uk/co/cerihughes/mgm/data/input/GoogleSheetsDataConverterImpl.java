package uk.co.cerihughes.mgm.data.input;

import com.google.gson.Gson;
import uk.co.cerihughes.mgm.model.AlbumType;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsEntry;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsFeed;
import uk.co.cerihughes.mgm.model.input.GoogleSheetsModel;
import uk.co.cerihughes.mgm.model.interim.InterimAlbum;
import uk.co.cerihughes.mgm.model.interim.InterimEvent;
import uk.co.cerihughes.mgm.model.interim.InterimPlaylist;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

public class GoogleSheetsDataConverterImpl implements GoogleSheetsDataConverter {
    private Gson gson = new Gson();

    public List<InterimEvent> convert(String json) {
        ArrayList<InterimEvent> events = new ArrayList<>();

        final GoogleSheetsModel model = deserialise(json);
        final GoogleSheetsFeed feed = model.getFeed();
        if (feed != null) {
            final List<GoogleSheetsEntry> entries = feed.resolvedEntries();
            for (GoogleSheetsEntry entry : entries) {
                events.add(createEvent(entry));
            }
        }

        return events.stream()
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private GoogleSheetsModel deserialise(String json) {
        return gson.fromJson(json, GoogleSheetsModel.class);
    }

    private InterimEvent createEvent(GoogleSheetsEntry entry) {
        final InterimAlbum classicAlbum = createClassicAlbum(entry);
        final InterimAlbum newAlbum = createNewAlbum(entry);

        return new InterimEvent.Builder()
                .setNumber(entry.resolvedId())
                .setDate(entry.resolvedDate())
                .setClassicAlbum(classicAlbum)
                .setNewAlbum(newAlbum)
                .setPlaylist(createPlaylist(entry))
                .build();
    }

    private InterimAlbum createClassicAlbum(GoogleSheetsEntry entry) {
        return createAlbum(AlbumType.CLASSIC,
                entry.resolvedClassicScore(),
                entry.resolvedClassicAlbum());
    }

    private InterimAlbum createNewAlbum(GoogleSheetsEntry entry) {
        return createAlbum(AlbumType.NEW,
                entry.resolvedNewScore(),
                entry.resolvedNewAlbum());
    }

    private InterimAlbum createAlbum(AlbumType type, String score, String albumData) {
        return new InterimAlbum.Builder()
                .setType(type)
                .setAlbumData(albumData)
                .setScore(score)
                .build();
    }

    private InterimPlaylist createPlaylist(GoogleSheetsEntry entry) {
        return new InterimPlaylist.Builder()
                .setPlaylistData(entry.resolvedPlaylist())
                .build();
    }
}
