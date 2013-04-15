package uk.co.cerihughes.denon.android.browse;

import java.util.ArrayList;
import java.util.List;

import uk.co.cerihughes.denon.android.AsyncCallbackTask;
import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.impl.lastfm.LastFmServiceDao;
import uk.co.cerihughes.denon.core.model.Artist;

public class LastFmGetFavouriteArtistsTask extends AsyncCallbackTask<String, Integer, List<Artist>, DaoException>
{
	@Override
	protected List<Artist> runInBackground(String... params) throws DaoException
	{
		final List<Artist> result = new ArrayList<Artist>();
		for (String param : params)
		{
			final LastFmServiceDao dao = new LastFmServiceDao(null, param);
			result.addAll(dao.getFavouriteArtists());
		}
		return result;
	}
}
