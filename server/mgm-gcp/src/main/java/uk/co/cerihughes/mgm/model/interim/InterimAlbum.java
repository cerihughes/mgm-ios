package uk.co.cerihughes.mgm.model.interim;

import uk.co.cerihughes.mgm.model.AlbumType;

public class InterimAlbum {
    private AlbumType type;
    private String spotifyId;
    private Float score;

    public AlbumType getType() {
        return type;
    }

    public void setType(AlbumType type) {
        this.type = type;
    }

    public String getSpotifyId() {
        return spotifyId;
    }

    public void setSpotifyId(String spotifyId) {
        this.spotifyId = spotifyId;
    }

    public Float getScore() {
        return score;
    }

    public void setScore(Float score) {
        this.score = score;
    }

    public void setScore(String scoreString) {
        Float score;
        try {
            score = new Float(scoreString);
        } catch (NumberFormatException | NullPointerException ex) {
            score = null;
        }
        setScore(score);
    }
}