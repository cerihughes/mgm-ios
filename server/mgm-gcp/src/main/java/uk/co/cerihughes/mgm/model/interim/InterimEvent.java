package uk.co.cerihughes.mgm.model.interim;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Optional;

public final class InterimEvent {
    private int number;
    private LocalDate date;
    private InterimAlbum classicAlbum;
    private InterimAlbum newAlbum;
    private InterimPlaylist playlist;

    private InterimEvent(int number, InterimAlbum classicAlbum, InterimAlbum newAlbum) {
        super();

        this.number = number;
        this.classicAlbum = classicAlbum;
        this.newAlbum = newAlbum;
    }

    public int getNumber() {
        return number;
    }

    public Optional<LocalDate> getDate() {
        return Optional.ofNullable(date);
    }

    public InterimAlbum getClassicAlbum() {
        return classicAlbum;
    }

    public InterimAlbum getNewAlbum() {
        return newAlbum;
    }

    public Optional<InterimPlaylist> getPlaylist() {
        return Optional.ofNullable(playlist);
    }

    public static final class Builder {
        private int number;
        private LocalDate date;
        private InterimAlbum classicAlbum;
        private InterimAlbum newAlbum;
        private InterimPlaylist playlist;

        public Builder(int number, InterimAlbum classicAlbum, InterimAlbum newAlbum) {
            super();

            this.number = number;
            this.classicAlbum = classicAlbum;
            this.newAlbum = newAlbum;
        }

        public Builder setDate(Optional<LocalDate> optionalDate) {
            optionalDate.ifPresent(value -> date = value);
            return this;
        }

        public Builder setPlaylist(Optional<InterimPlaylist> optionalPlaylist) {
            optionalPlaylist.ifPresent(value -> playlist = value);
            return this;
        }

        public Builder setDateString(Optional<String> dateString, DateTimeFormatter formatter) {
            try {
                setDate(dateString.map(value -> LocalDate.parse(value, formatter)));
            } catch (DateTimeParseException e) {
                // Swallow
            }
            return this;
        }

        public Optional<InterimEvent> build() {
            if (classicAlbum == null || newAlbum == null) {
                return Optional.empty();
            }
            final InterimEvent event = new InterimEvent(number, classicAlbum, newAlbum);
            event.date = date;
            event.playlist = playlist;
            return Optional.of(event);
        }
    }
}