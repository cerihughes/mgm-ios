package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

import java.util.Optional;

public class OutputLocation {
    @SerializedName("name")
    private String name;
    @SerializedName("latitude")
    private double latitude;
    @SerializedName("longitude")
    private double longitude;

    private OutputLocation(String name, double latitude, double longitude) {
        super();

        this.name = name;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public static final class Builder {
        private String name;
        private double latitude;
        private double longitude;

        public Builder(String name, double latitude, double longitude) {
            super();

            this.name = name;
            this.latitude = latitude;
            this.longitude = longitude;
        }

        public Optional<OutputLocation> build() {
            if (name == null) {
                return Optional.empty();
            }
            final OutputLocation location = new OutputLocation(name, latitude, longitude);
            return Optional.of(location);
        }
    }
}
