package uk.co.cerihughes.mgm.model.interim;

import uk.co.cerihughes.mgm.model.AlbumType;

public final class InterimAlbum {
    private AlbumType type;
    private String albumData;
    private Float score;

    private InterimAlbum() {
        super();
    }

    public AlbumType getType() {
        return type;
    }

    public String getAlbumData() {
        return albumData;
    }

    public Float getScore() {
        return score;
    }

    public static final class Builder {
        private AlbumType type;
        private String albumData;
        private Float score;

        public Builder setType(AlbumType type) {
            this.type = type;
            return this;
        }

        public Builder setAlbumData(String albumData) {
            this.albumData = albumData;
            return this;
        }

        public Builder setScore(Float score) {
            this.score = score;
            return this;
        }

        public Builder setScore(String scoreString) {
            try {
                setScore(new Float(scoreString));
            } catch (NullPointerException | NumberFormatException e) {
                // Swallow
            }
            return this;
        }

        public InterimAlbum build() {
            if (type == null || albumData == null || albumData.trim().length() == 0) {
                return null;
            }
            final InterimAlbum album = new InterimAlbum();
            album.type = type;
            album.albumData = albumData;
            album.albumData = albumData;
            album.score = score;
            return album;
        }
    }
}