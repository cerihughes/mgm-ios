package uk.co.cerihughes.denonpiccoloremote.core.model;

import java.util.Date;

public class Playlist extends MusicItem
{
	private String description;
	private Date creationDate;

	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	public Date getCreationDate()
	{
		return creationDate;
	}

	public void setCreationDate(Date creationDate)
	{
		this.creationDate = creationDate;
	}
}
