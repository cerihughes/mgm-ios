package uk.co.cerihughes.mgm.model.output;

import com.google.gson.annotations.SerializedName;

import java.util.Optional;

public final class OutputImage {
    @SerializedName("size")
    private int size;
    @SerializedName("url")
    private String url;

    private OutputImage(int size, String url) {
        super();

        this.size = size;
        this.url = url;
    }

    public static final class Builder {
        private int size;
        private String url;

        public Builder(int size, String url) {
            super();

            this.size = size;
            this.url = url;
        }

        public Optional<OutputImage> build() {
            if (url == null) {
                return Optional.empty();
            }
            final OutputImage image = new OutputImage(size, url);
            return Optional.of(image);
        }
    }
}