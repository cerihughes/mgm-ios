package uk.co.cerihughes.denon.android;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.impl.lastfm.LastFmServiceDao;

public class LastFmLoginTask extends AsyncCallbackTask<String, Integer, String, DaoException>
{
	@Override
	protected String runInBackground(String... params) throws DaoException
	{
		if (params.length == 1)
		{
			final LastFmServiceDao dao = new LastFmServiceDao(null, "hughesceri");
			return dao.getMobileSession(params[0]);
		}
		throw new DaoException("Only 1 password can be processed.");
	}
}
