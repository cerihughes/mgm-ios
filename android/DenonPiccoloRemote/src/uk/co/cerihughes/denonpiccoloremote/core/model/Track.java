package uk.co.cerihughes.denonpiccoloremote.core.model;

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
