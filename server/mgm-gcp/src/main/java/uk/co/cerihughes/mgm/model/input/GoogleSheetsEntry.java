package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

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

    public String resolvedId() {
        return resolve(id);
    }

    public String resolvedDate() {
        return resolve(date);
    }

    public String resolvedPlaylist() {
        return resolve(playlist);
    }

    public String resolvedClassicAlbum() {
        return resolve(classicAlbum);
    }

    public String resolvedClassicScore() {
        return resolve(classicScore);
    }

    public String resolvedNewAlbum() {
        return resolve(newAlbum);
    }

    public String resolvedNewScore() {
        return resolve(newScore);
    }

    private String resolve(GoogleSheetsString string) {
        return string == null ? null : string.resolvedValue();
    }
}