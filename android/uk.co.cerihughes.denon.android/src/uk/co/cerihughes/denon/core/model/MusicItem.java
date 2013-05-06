package uk.co.cerihughes.denon.core.model;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import uk.co.cerihughes.denon.core.dao.EDaoType;

public class MusicItem extends EHTObject
{
	private Map<String, String> attributes = new HashMap<String, String>();
	private EDaoType source;
	private String id;
	private String name;
	private String uri;
	private Float popularity;
	private String imageUri;

	@EHT(field = "source")
	public EDaoType getSource()
	{
		return source;
	}

	public void setSource(EDaoType source)
	{
		this.source = source;
	}

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

	@EHT(field = "uri")
	public String getUri()
	{
		return uri;
	}

	public void setUri(String uri)
	{
		this.uri = uri;
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
