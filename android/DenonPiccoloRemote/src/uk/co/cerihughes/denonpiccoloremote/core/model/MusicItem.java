package uk.co.cerihughes.denonpiccoloremote.core.model;

public class MusicItem
{
	private String name;
	private String location;
	private Float popularity;
	private String imageUri;

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getLocation()
	{
		return location;
	}

	public void setLocation(String location)
	{
		this.location = location;
	}

	public Float getPopularity()
	{
		return popularity;
	}

	public void setPopularity(Float popularity)
	{
		this.popularity = popularity;
	}

	public String getImageUri()
	{
		return imageUri;
	}

	public void setImageUri(String imageUri)
	{
		this.imageUri = imageUri;
	}

}
