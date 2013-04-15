package uk.co.cerihughes.denon.android.browse;

import java.util.ArrayList;
import java.util.List;

import uk.co.cerihughes.denon.android.AsyncCallbackTask;
import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.impl.lastfm.LastFmServiceDao;
import uk.co.cerihughes.denon.core.model.Album;

public class LastFmGetFavouriteAlbumsTask extends AsyncCallbackTask<String, Integer, List<Album>, DaoException>
{
	@Override
	protected List<Album> runInBackground(String... params) throws DaoException
	{
		final List<Album> result = new ArrayList<Album>();
		for (String param : params)
		{
			final LastFmServiceDao dao = new LastFmServiceDao(null, param);
			result.addAll(dao.getFavouriteAlbums());
		}
		return result;
	}
}
