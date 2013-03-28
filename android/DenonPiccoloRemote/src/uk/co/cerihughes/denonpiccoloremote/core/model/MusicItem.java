package uk.co.cerihughes.denonpiccoloremote.core.model;


public class MusicItem {
	private String location;
	private Float popularity;

	public Float getPopularity() {
		return popularity;
	}

	public void setPopularity(Float popularity) {
		this.popularity = popularity;
	}

	public String getLocation() {
		return location;
	}

	public void setLocation(String location) {
		this.location = location;
	}
}
