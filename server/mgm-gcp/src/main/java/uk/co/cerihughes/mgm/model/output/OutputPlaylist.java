package uk.co.cerihughes.mgm.model.output;

public class OutputPlaylist {
    private String spotifyID;
    private String name;
    private String owner;
    private OutputImages images;

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

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public OutputImages getImages() {
        return images;
    }

    public void setImages(OutputImages images) {
        this.images = images;
    }
}
