package uk.co.cerihughes.denon.android;

import java.util.Collection;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.impl.dlna.DlnaServiceDao;
import uk.co.cerihughes.denon.core.model.Artist;
import android.os.AsyncTask;

public class DlnaArtistsTask extends AsyncTask<String, Integer, AsyncTaskResult<Collection<Artist>>>
{
	private DlnaServiceDao dao;

	public DlnaArtistsTask(DlnaServiceDao dao)
	{
		super();
		this.dao = dao;
	}

	@Override
	protected AsyncTaskResult<Collection<Artist>> doInBackground(String... params)
	{

		try
		{
			return new AsyncTaskResult<Collection<Artist>>(dao.allArtists());
		}
		catch (DaoException ex)
		{
			return new AsyncTaskResult<Collection<Artist>>(ex);
		}
	}

	@Override
	protected void onPostExecute(AsyncTaskResult<Collection<Artist>> result)
	{
	}

}
