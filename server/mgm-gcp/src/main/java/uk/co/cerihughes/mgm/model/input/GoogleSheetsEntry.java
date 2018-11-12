package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.Optional;

public class GoogleSheetsEntry {
    @SerializedName("gsx$id")
    private GoogleSheetsString id;
    @SerializedName("gsx$date")
    private GoogleSheetsString date;
    @SerializedName("gsx$playlist")
    private GoogleSheetsString playlist;
    @SerializedName("gsx$classicalbum")
    private GoogleSheetsString classicAlbum;
    @SerializedName("gsx$classicscore")
    private GoogleSheetsString classicScore;
    @SerializedName("gsx$newalbum")
    private GoogleSheetsString newAlbum;
    @SerializedName("gsx$newscore")
    private GoogleSheetsString newScore;

    public Optional<String> resolvedId() {
        return resolve(id);
    }

    public Optional<String> resolvedDate() {
        return resolve(date);
    }

    public Optional<String> resolvedPlaylist() {
        return resolve(playlist);
    }

    public Optional<String> resolvedClassicAlbum() {
        return resolve(classicAlbum);
    }

    public Optional<String> resolvedClassicScore() {
        return resolve(classicScore);
    }

    public Optional<String> resolvedNewAlbum() {
        return resolve(newAlbum);
    }

    public Optional<String> resolvedNewScore() {
        return resolve(newScore);
    }

    private Optional<String> resolve(GoogleSheetsString string) {
        return Optional.ofNullable(string).flatMap(s -> s.resolvedValue());
    }
}