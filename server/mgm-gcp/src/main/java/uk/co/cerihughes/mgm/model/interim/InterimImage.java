package uk.co.cerihughes.mgm.model.interim;

import java.util.Optional;

public final class InterimImage {
    private Integer size;
    private String url;

    private InterimImage(String url) {
        super();

        this.url = url;
    }

    public Optional<Integer> getSize() {
        return Optional.ofNullable(size);
    }

    public String getUrl() {
        return url;
    }

    public static final class Builder {
        private Integer size;
        private String url;

        public Builder(String url) {
            super();

            this.url = url;
        }

        public Builder setSize(Optional<Integer> optionalSize) {
            optionalSize.ifPresent(value -> size = size);
            return this;
        }

        public Builder setSizeString(Optional<String> sizeString) {
            try {
                setSize(sizeString.map(Integer::new));
            } catch (NumberFormatException e) {
                // Swallow
            }
            return this;
        }

        public Optional<InterimImage> build() {
            if (url == null) {
                return Optional.empty();
            }
            final InterimImage image = new InterimImage(url);
            image.size = size;
            return Optional.of(image);
        }
    }
}