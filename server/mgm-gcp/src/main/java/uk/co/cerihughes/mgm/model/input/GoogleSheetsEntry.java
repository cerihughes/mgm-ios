package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

import java.util.Optional;

public class GoogleSheetsEntry {
    @SerializedName("gsx$id")
    private GoogleSheetsString id;
    @SerializedName("gsx$eventdate")
    private GoogleSheetsString date;
    @SerializedName("gsx$playlist")
    private GoogleSheetsString playlist;
    @SerializedName("gsx$classicspotifyid")
    private GoogleSheetsString classicSpotifyId;
    @SerializedName("gsx$classicscore")
    private GoogleSheetsString classicScore;
    @SerializedName("gsx$newspotifyid")
    private GoogleSheetsString newSpotifyId;
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

    public Optional<String> resolvedClassicSpotifyId() {
        return resolve(classicSpotifyId);
    }

    public Optional<String> resolvedClassicScore() {
        return resolve(classicScore);
    }

    public Optional<String> resolvedNewSpotifyId() {
        return resolve(newSpotifyId);
    }

    public Optional<String> resolvedNewScore() {
        return resolve(newScore);
    }

    private Optional<String> resolve(GoogleSheetsString string) {
        return Optional.ofNullable(string).flatMap(s -> s.resolvedValue());
    }
}