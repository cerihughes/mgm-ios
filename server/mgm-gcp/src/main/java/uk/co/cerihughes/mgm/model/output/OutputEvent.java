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

    private OutputEvent(int number) {
        super();

        this.number = number;
    }

    public static final class Builder {
        private int number;
        private LocalDate date;
        private OutputLocation location;
        private OutputAlbum classicAlbum;
        private OutputAlbum newAlbum;
        private OutputPlaylist playlist;

        public Builder(int number) {
            super();

            this.number = number;
        }

        public Builder setClassicAlbum(Optional<OutputAlbum> optionalClassicAlbum) {
            optionalClassicAlbum.ifPresent(value -> classicAlbum = value);
            return this;
        }

        public Builder setNewAlbum(Optional<OutputAlbum> optionalNewAlbum) {
            optionalNewAlbum.ifPresent(value -> newAlbum = value);
            return this;
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
            final OutputEvent event = new OutputEvent(number);
            event.date = date;
            event.location = location;
            event.classicAlbum = classicAlbum;
            event.newAlbum = newAlbum;
            event.playlist = playlist;
            return Optional.of(event);
        }

    }
}
