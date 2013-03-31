package uk.co.cerihughes.denonpiccoloremote;

import uk.co.cerihughes.denonpiccoloremote.core.dao.DaoException;
import uk.co.cerihughes.denonpiccoloremote.core.dao.impl.LastFmServiceDao;
import android.os.AsyncTask;

public class LastFmLoginTask extends AsyncTask<String, Integer, AsyncTaskResult<String>>
{
	private static final String API_KEY = "c906b96ff00fac94c2cde40b3f9dbf19";
	private static final String API_SECRET = "f4280454e04778b9eaaf320b977c3b78";

	@Override
	protected AsyncTaskResult<String> doInBackground(String... params)
	{
		if (params.length == 1)
		{
			final LastFmServiceDao dao = new LastFmServiceDao(null, API_KEY, API_SECRET, "hughesceri");
			try
			{
				return new AsyncTaskResult<String>(dao.getMobileSession(params[0]));
			}
			catch (DaoException ex)
			{
				return new AsyncTaskResult<String>(ex);
			}
		}
		return new AsyncTaskResult<String>(new DaoException("Only 1 password can be processed."));
	}

	@Override
	protected void onPostExecute(AsyncTaskResult<String> result)
	{
	}
}
