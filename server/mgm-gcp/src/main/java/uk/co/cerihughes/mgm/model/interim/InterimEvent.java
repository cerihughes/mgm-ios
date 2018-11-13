package uk.co.cerihughes.mgm.model.interim;

import uk.co.cerihughes.mgm.data.DateTimeFormatterFactory;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public final class InterimEvent {
    private int number;
    private LocalDate date;
    private InterimAlbum classicAlbum;
    private InterimAlbum newAlbum;
    private InterimPlaylist playlist;

    private InterimEvent(int number) {
        super();

        this.number = number;
    }

    public int getNumber() {
        return number;
    }

    public LocalDate getDate() {
        return date;
    }

    public InterimAlbum getClassicAlbum() {
        return classicAlbum;
    }

    public InterimAlbum getNewAlbum() {
        return newAlbum;
    }

    public InterimPlaylist getPlaylist() {
        return playlist;
    }

    public static final class Builder {
        private static DateTimeFormatter formatter = DateTimeFormatterFactory.formatter;

        private Integer number;
        private LocalDate date;
        private InterimAlbum classicAlbum;
        private InterimAlbum newAlbum;
        private InterimPlaylist playlist;

        public Builder setNumber(Integer number) {
            this.number = number;
            return this;
        }

        public Builder setNumber(String number) {
            try {
                setNumber(new Integer(number));
            } catch (NullPointerException | NumberFormatException e) {
                // Swallow
            }
            return this;
        }

        public Builder setDate(LocalDate date) {
            this.date = date;
            return this;
        }

        public Builder setDate(String dateString) {
            try {
                setDate(LocalDate.parse(dateString, formatter));
            } catch (NullPointerException | DateTimeParseException e) {
                // Swallow
            }
            return this;
        }

        public Builder setClassicAlbum(InterimAlbum classicAlbum) {
            this.classicAlbum = classicAlbum;
            return this;
        }

        public Builder setNewAlbum(InterimAlbum newAlbum) {
            this.newAlbum = newAlbum;
            return this;
        }

        public Builder setPlaylist(InterimPlaylist playlist) {
            this.playlist = playlist;
            return this;
        }

        public InterimEvent build() {
            if (number == null || classicAlbum == null || newAlbum == null) {
                return null;
            }
            final InterimEvent event = new InterimEvent(number);
            event.date = date;
            event.classicAlbum = classicAlbum;
            event.newAlbum = newAlbum;
            event.playlist = playlist;
            return event;
        }
    }
}