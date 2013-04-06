package uk.co.cerihughes.denon.core.model;

public class MusicItem extends EHTObject
{
	private String name;
	private String location;
	private Float popularity;
	private String imageUri;

	@EHT(field="name")
	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	@EHT(field="location")
	public String getLocation()
	{
		return location;
	}

	public void setLocation(String location)
	{
		this.location = location;
	}

	@EHT(field="popularity")
	public Float getPopularity()
	{
		return popularity;
	}

	public void setPopularity(Float popularity)
	{
		this.popularity = popularity;
	}

	@EHT(field="imageUri")
	public String getImageUri()
	{
		return imageUri;
	}

	public void setImageUri(String imageUri)
	{
		this.imageUri = imageUri;
	}
}
