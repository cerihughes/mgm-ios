package uk.co.cerihughes.mgm.model.output;

import java.time.LocalDate;

public class OutputEvent {
    private int number;
    private LocalDate date;
    private OutputLocation location;
    private OutputAlbum classicAlbum;
    private OutputAlbum newAlbum;
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
