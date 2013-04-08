package uk.co.cerihughes.denon.core.model;

public class Album extends MusicItem
{
	private String artistName;

	@EHT(field = "artistName")
	public String getArtitsName()
	{
		return artistName;
	}

	public void setArtistName(String artistName)
	{
		this.artistName = artistName;
	}
}
