package uk.co.cerihughes.mgm.model.interim;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class InterimEvent {
    private Integer number;
    private LocalDate date;
    private InterimAlbum classicAlbum;
    private InterimAlbum newAlbum;
    private InterimPlaylist playlist;

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public InterimAlbum getClassicAlbum() {
        return classicAlbum;
    }

    public void setClassicAlbum(InterimAlbum classicAlbum) {
        this.classicAlbum = classicAlbum;
    }

    public InterimAlbum getNewAlbum() {
        return newAlbum;
    }

    public void setNewAlbum(InterimAlbum newAlbum) {
        this.newAlbum = newAlbum;
    }

    public InterimPlaylist getPlaylist() {
        return playlist;
    }

    public void setPlaylist(InterimPlaylist playlist) {
        this.playlist = playlist;
    }

    public void setNumber(String numberString) {
        Integer number;
        try {
            number = new Integer(numberString);
        } catch (NumberFormatException | NullPointerException ex) {
            number = null;
        }
        setNumber(number);
    }

    public void setDate(String dateString, DateTimeFormatter formatter) {
        LocalDate date;
        try {
            date = LocalDate.parse(dateString, formatter);
        } catch (DateTimeParseException | NullPointerException ex) {
            date = null;
        }
        setDate(date);
    }
}