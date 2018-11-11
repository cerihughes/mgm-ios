package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

import java.time.LocalDate;
import java.util.Optional;

public final class OutputEvent {
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

    private OutputEvent(int number, OutputAlbum classicAlbum, OutputAlbum newAlbum) {
        super();

        this.number = number;
        this.classicAlbum = classicAlbum;
        this.newAlbum = newAlbum;
    }

    public static final class Builder {
        private int number;
        private LocalDate date;
        private OutputLocation location;
        private OutputAlbum classicAlbum;
        private OutputAlbum newAlbum;
        private OutputPlaylist playlist;

        public Builder(int number, OutputAlbum classicAlbum, OutputAlbum newAlbum) {
            super();

            this.number = number;
            this.classicAlbum = classicAlbum;
            this.newAlbum = newAlbum;
        }

        public Builder setDate(Optional<LocalDate> optionalDate) {
            optionalDate.ifPresent(value -> date = value);
            return this;
        }

        public Builder setLocation(Optional<OutputLocation> optionalLocation) {
            optionalLocation.ifPresent(value -> location = value);
            return this;
        }

        public Builder setPlaylist(Optional<OutputPlaylist> optionalPlaylist) {
            optionalPlaylist.ifPresent(value -> playlist = value);
            return this;
        }

        public Optional<OutputEvent> build() {
            if (classicAlbum == null || newAlbum == null) {
                return Optional.empty();
            }
            final OutputEvent event = new OutputEvent(number, classicAlbum, newAlbum);
            event.date = date;
            event.location = location;
            event.playlist = playlist;
            return Optional.of(event);
        }

    }
}
