package uk.co.cerihughes.denon.core.model;

import java.util.Date;

public class Playlist extends MusicItem
{
	private String description;
	private Integer trackCount;
	private Date creationDate;

	@EHT(field = "description")
	public String getDescription()
	{
		return description;
	}

	public void setDescription(String description)
	{
		this.description = description;
	}

	@EHT(field = "trackCount")
	public Integer getTrackCount()
	{
		return trackCount;
	}

	public void setTrackCount(Integer trackCount)
	{
		this.trackCount = trackCount;
	}

	@EHT(field = "creationDate")
	public Date getCreationDate()
	{
		return creationDate;
	}

	public void setCreationDate(Date creationDate)
	{
		this.creationDate = creationDate;
	}
}
