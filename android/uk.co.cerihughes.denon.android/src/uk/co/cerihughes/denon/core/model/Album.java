package uk.co.cerihughes.denon.core.model;

import java.util.Date;

public class Album extends MusicItem
{
	private Date releaseDate;
	private String artistName;
	private Integer discCount;
	private Integer trackCount;

	@EHT(field = "releaseDate")
	public Date getReleaseDate()
	{
		return releaseDate;
	}

	public void setReleaseDate(Date releaseDate)
	{
		this.releaseDate = releaseDate;
	}

	@EHT(field = "artistName")
	public String getArtistName()
	{
		return artistName;
	}

	public void setArtistName(String artistName)
	{
		this.artistName = artistName;
	}

	@EHT(field = "discCount")
	public Integer getDiscCount()
	{
		return discCount;
	}

	public void setDiscCount(Integer discCount)
	{
		this.discCount = discCount;
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
}
