package uk.co.cerihughes.denon.core.model;

import java.util.Date;

public class RecentItem extends EHTObject
{
	private final MusicItem item;
	private final Date lastAccessed;

	public RecentItem(MusicItem item, Date lastAccessed)
	{
		super();
		this.item = item;
		this.lastAccessed = lastAccessed;
	}

	@EHT(field = "item")
	public MusicItem getItem()
	{
		return item;
	}

	@EHT(field = "lastAccessed")
	public Date getLastAccessed()
	{
		return lastAccessed;
	}
}
