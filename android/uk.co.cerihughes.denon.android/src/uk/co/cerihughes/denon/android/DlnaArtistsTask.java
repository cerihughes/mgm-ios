package uk.co.cerihughes.denon.android;

import java.util.Collection;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.impl.dlna.DlnaServiceDao;
import uk.co.cerihughes.denon.core.model.Artist;

public class DlnaArtistsTask extends AsyncCallbackTask<String, Integer, Collection<Artist>, DaoException>
{
	private DlnaServiceDao dao;

	public DlnaArtistsTask(DlnaServiceDao dao)
	{
		super();
		this.dao = dao;
	}

	@Override
	protected Collection<Artist> runInBackground(String... params) throws DaoException
	{
		return dao.getAllArtists();
	}

}
