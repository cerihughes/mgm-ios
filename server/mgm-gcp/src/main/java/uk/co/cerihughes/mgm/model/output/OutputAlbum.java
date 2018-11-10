package uk.co.cerihughes.mgm.model.output;

public class OutputAlbum {
    public enum Type {CLASSIC, NEW}

    private Type type;
    private String spotifyID;
    private String name;
    private String artist;
    private Float score;
    private OutputImages images;

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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public Float getScore() {
        return score;
    }

    public void setScore(Float score) {
        this.score = score;
    }

    public OutputImages getImages() {
        return images;
    }

    public void setImages(OutputImages images) {
        this.images = images;
    }
}
