package uk.co.cerihughes.denon.android;

import java.util.List;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.model.Album;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

public class FavouriteAlbumsPageFragment extends ListFragment implements AsyncCallback<List<Album>, DaoException>
{
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		// Inflate the layout containing a title and body text.
		return inflater.inflate(R.layout.albums_slide_page, container, false);
	}

	@Override
	public void onViewCreated(View view, Bundle savedInstanceState)
	{
		super.onViewCreated(view, savedInstanceState);
		final LastFmGetFavouriteAlbumsTask task = new LastFmGetFavouriteAlbumsTask();
		task.execute(this, "hughesceri");
	}

	@Override
	public void callbackSuccess(List<Album> result)
	{
		Album[] array = new Album[result.size()];
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
