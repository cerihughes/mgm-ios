package uk.co.cerihughes.denon.core.model;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

public class MusicItem extends EHTObject
{
	private Map<String, String> attributes = new HashMap<String, String>();
	private String id;
	private String name;
	private String location;
	private Float popularity;
	private String imageUri;

	@EHT(field = "id")
	public String getId()
	{
		return id;
	}

	public void setId(String id)
	{
		this.id = id;
	}

	@EHT(field = "name")
	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	@EHT(field = "location")
	public String getLocation()
	{
		return location;
	}

	public void setLocation(String location)
	{
		this.location = location;
	}

	@EHT(field = "popularity")
	public Float getPopularity()
	{
		return popularity;
	}

	public void setPopularity(Float popularity)
	{
		this.popularity = popularity;
	}

	@EHT(field = "imageUri")
	public String getImageUri()
	{
		return imageUri;
	}

	public void setImageUri(String imageUri)
	{
		this.imageUri = imageUri;
	}

	@EHT(field = "attributes")
	public Map<String, String> getAttributes()
	{
		return Collections.unmodifiableMap(attributes);
	}

	public String getAttribute(String key)
	{
		return attributes.get(key);
	}

	public void putAttribute(String key, String value)
	{
		attributes.put(key, value);
	}
}
