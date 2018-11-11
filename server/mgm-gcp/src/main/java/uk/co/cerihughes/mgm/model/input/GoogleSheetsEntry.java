package uk.co.cerihughes.mgm.model.input;

import com.google.gson.annotations.SerializedName;

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

    public GoogleSheetsString getId() {
        return id;
    }

    public void setId(GoogleSheetsString id) {
        this.id = id;
    }

    public GoogleSheetsString getDate() {
        return date;
    }

    public void setDate(GoogleSheetsString date) {
        this.date = date;
    }

    public GoogleSheetsString getPlaylist() {
        return playlist;
    }

    public void setPlaylist(GoogleSheetsString playlist) {
        this.playlist = playlist;
    }

    public GoogleSheetsString getClassicSpotifyId() {
        return classicSpotifyId;
    }

    public void setClassicSpotifyId(GoogleSheetsString classicSpotifyId) {
        this.classicSpotifyId = classicSpotifyId;
    }

    public GoogleSheetsString getClassicScore() {
        return classicScore;
    }

    public void setClassicScore(GoogleSheetsString classicScore) {
        this.classicScore = classicScore;
    }

    public GoogleSheetsString getNewSpotifyId() {
        return newSpotifyId;
    }

    public void setNewSpotifyId(GoogleSheetsString newSpotifyId) {
        this.newSpotifyId = newSpotifyId;
    }

    public GoogleSheetsString getNewScore() {
        return newScore;
    }

    public void setNewScore(GoogleSheetsString newScore) {
        this.newScore = newScore;
    }

    public String resolvedId() {
        return id == null ? null : id.resolvedValue();
    }

    public String resolvedDate() {
        return date == null ? null : date.resolvedValue();
    }

    public String resolvedPlaylist() {
        return playlist == null ? null : playlist.resolvedValue();
    }

    public String resolvedClassicSpotifyId() {
        return classicSpotifyId == null ? null : classicSpotifyId.resolvedValue();
    }

    public String resolvedClassicScore() {
        return classicScore == null ? null : classicScore.resolvedValue();
    }

    public String resolvedNewSpotifyId() {
        return newSpotifyId == null ? null : newSpotifyId.resolvedValue();
    }

    public String resolvedNewScore() {
        return newScore == null ? null : newScore.resolvedValue();
    }
}