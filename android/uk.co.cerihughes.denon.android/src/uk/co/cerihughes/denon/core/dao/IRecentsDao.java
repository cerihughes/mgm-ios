package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.MusicItem;
import uk.co.cerihughes.denon.core.model.RecentItem;

public interface IRecentsDao
{
	List<RecentItem> getRecentItems(int limit);

	void addRecentItem(MusicItem item);
}
