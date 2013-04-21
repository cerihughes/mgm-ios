package uk.co.cerihughes.denon.core.dao.impl.lastfm;

public class LastFmNewAlbumReleasesJsonConverter extends LastFmMostPlayedAlbumsJsonConverter
{
	@Override
	protected String getTopLevelKey()
	{
		return "albums";
	}
}
