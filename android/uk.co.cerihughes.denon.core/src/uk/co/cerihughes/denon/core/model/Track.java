package uk.co.cerihughes.denon.core.model;

public class Track extends MusicItem
{
	private Integer length;

	@EHT(field="length")
	public Integer getLength()
	{
		return length;
	}

	public void setLength(Integer length)
	{
		this.length = length;
	}
}
