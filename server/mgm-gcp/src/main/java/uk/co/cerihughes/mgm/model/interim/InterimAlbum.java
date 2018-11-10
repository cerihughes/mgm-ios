package uk.co.cerihughes.mgm.model.interim;

public class InterimAlbum {
    public enum Type {CLASSIC, NEW}

    private Type type;
    private String spotifyID;
    private Float score;

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public String getSpotifyID() {
        return spotifyID;
    }

    public void setSpotifyID(String spotifyID) {
        this.spotifyID = spotifyID;
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