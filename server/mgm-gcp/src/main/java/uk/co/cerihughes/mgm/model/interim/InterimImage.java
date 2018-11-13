package uk.co.cerihughes.mgm.model.interim;

public final class InterimImage {
    private Integer size;
    private String url;

    private InterimImage() {
        super();
    }

    public Integer getSize() {
        return size;
    }

    public String getUrl() {
        return url;
    }

    public static final class Builder {
        private Integer size;
        private String url;

        public Builder setSize(Integer size) {
            this.size = size;
            return this;
        }

        public Builder setSize(String sizeString) {
            try {
                setSize(new Integer(sizeString));
            } catch (NullPointerException | NumberFormatException e) {
                // Swallow
            }
            return this;
        }

        public Builder setUrl(String url) {
            this.url = url;
            return this;
        }

        public InterimImage build() {
            if (url == null || url.trim().length() == 0) {
                return null;
            }
            final InterimImage image = new InterimImage();
            image.size = size;
            image.url = url;
            return image;
        }
    }
}