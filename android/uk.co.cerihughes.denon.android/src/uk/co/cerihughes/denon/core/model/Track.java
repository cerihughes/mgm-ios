package uk.co.cerihughes.denon.core.model;

public class Track extends MusicItem
{
	private Integer trackNumber;
	private Integer discNumber;
	private Integer length;
	private String albumName;
	private String artistName;

	@EHT(field = "trackNumber")
	public Integer getTrackNumber()
	{
		return trackNumber;
	}

	public void setTrackNumber(Integer trackNumber)
	{
		this.trackNumber = trackNumber;
	}

	@EHT(field = "discNumber")
	public Integer getDiscNumber()
	{
		return discNumber;
	}

	public void setDiscNumber(Integer discNumber)
	{
		this.discNumber = discNumber;
	}

	@EHT(field = "length")
	public Integer getLength()
	{
		return length;
	}

	public void setLength(Integer length)
	{
		this.length = length;
	}

	@EHT(field = "albumName")
	public String getAlbumName()
	{
		return albumName;
	}

	public void setAlbumName(String albumName)
	{
		this.albumName = albumName;
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
}
