package uk.co.cerihughes.denon.android.browse;

import java.util.ArrayList;
import java.util.List;

import uk.co.cerihughes.denon.android.AsyncCallbackTask;
import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.impl.lastfm.LastFmServiceDao;
import uk.co.cerihughes.denon.core.model.Track;

public class LastFmGetFavouriteTracksTask extends AsyncCallbackTask<String, Integer, List<Track>, DaoException>
{
	@Override
	protected List<Track> runInBackground(String... params) throws DaoException
	{
		final List<Track> result = new ArrayList<Track>();
		for (String param : params)
		{
			final LastFmServiceDao dao = new LastFmServiceDao(null, param);
			result.addAll(dao.getMostPlayedTracks());
		}
		return result;
	}
}
