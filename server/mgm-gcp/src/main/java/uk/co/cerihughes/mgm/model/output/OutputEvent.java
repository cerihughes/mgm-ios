package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

import java.time.LocalDate;

public class OutputEvent {
    @SerializedName("number")
    private int number;
    @SerializedName("date")
    private LocalDate date;
    @SerializedName("location")
    private OutputLocation location;
    @SerializedName("classicAlbum")
    private OutputAlbum classicAlbum;
    @SerializedName("newAlbum")
    private OutputAlbum newAlbum;
    @SerializedName("playlist")
    private OutputPlaylist playlist;

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public OutputLocation getLocation() {
        return location;
    }

    public void setLocation(OutputLocation location) {
        this.location = location;
    }

    public OutputAlbum getClassicAlbum() {
        return classicAlbum;
    }

    public void setClassicAlbum(OutputAlbum classicAlbum) {
        this.classicAlbum = classicAlbum;
    }

    public OutputAlbum getNewAlbum() {
        return newAlbum;
    }

    public void setNewAlbum(OutputAlbum newAlbum) {
        this.newAlbum = newAlbum;
    }

    public OutputPlaylist getPlaylist() {
        return playlist;
    }

    public void setPlaylist(OutputPlaylist playlist) {
        this.playlist = playlist;
    }
}
