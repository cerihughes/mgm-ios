package uk.co.cerihughes.denon.core.model;

import java.util.Date;

public class Album extends MusicItem
{
	private Date releaseDate;
	private String artistName;
	private Integer discs;

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

	@EHT(field = "discs")
	public Integer getDiscs()
	{
		return discs;
	}

	public void setDiscs(Integer discs)
	{
		this.discs = discs;
	}
}
