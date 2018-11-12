package uk.co.cerihughes.mgm.model.interim;

import uk.co.cerihughes.mgm.model.AlbumType;

import java.util.Optional;

public final class InterimAlbum {
    private AlbumType type;
    private String albumData;
    private Float score;

    private InterimAlbum(AlbumType type, String albumData) {
        super();

        this.type = type;
        this.albumData = albumData;
    }

    public AlbumType getType() {
        return type;
    }

    public String getAlbumData() {
        return albumData;
    }

    public Optional<Float> getScore() {
        return Optional.ofNullable(score);
    }

    public static final class Builder {
        private AlbumType type;
        private String albumData;
        private Float score;

        public Builder(AlbumType type, String albumData) {
            super();

            this.type = type;
            this.albumData = albumData;
        }

        public Builder setScore(Optional<Float> optionalScore) {
            optionalScore.ifPresent(value -> score = value);
            return this;
        }

        public Builder setScoreString(Optional<String> scoreString) {
            try {
                setScore(scoreString.map(Float::new));
            } catch (NumberFormatException e) {
                // Swallow
            }
            return this;
        }

        public Optional<InterimAlbum> build() {
            if (type == null || albumData == null) {
                return Optional.empty();
            }
            final InterimAlbum album = new InterimAlbum(type, albumData);
            album.albumData = albumData;
            album.score = score;
            return Optional.of(album);
        }
    }
}