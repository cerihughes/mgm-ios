package uk.co.cerihughes.denon.android.browse;

import java.util.List;

import uk.co.cerihughes.denon.android.AsyncCallback;
import uk.co.cerihughes.denon.android.ImageAdapter;
import uk.co.cerihughes.denon.android.R;
import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.model.Track;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class FavouriteTracksPageFragment extends ListFragment implements AsyncCallback<List<Track>, DaoException>
{
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		// Inflate the layout containing a title and body text.
		return inflater.inflate(R.layout.tracks_slide_page, container, false);
	}

	@Override
	public void onViewCreated(View view, Bundle savedInstanceState)
	{
		super.onViewCreated(view, savedInstanceState);
		final LastFmGetFavouriteTracksTask task = new LastFmGetFavouriteTracksTask();
		task.execute(this, "hughesceri");
	}

	@Override
	public void callbackSuccess(List<Track> result)
	{
		Track[] array = new Track[result.size()];
		array = result.toArray(array);
		final ImageAdapter adapter = new ImageAdapter(array);
		setListAdapter(adapter);
	}

	@Override
	public void callbackFailure(DaoException failure)
	{
		// TODO Auto-generated method stub

	}

	@Override
	public void callbackRuntimeException(RuntimeException rex)
	{
		// TODO Auto-generated method stub

	}
}
