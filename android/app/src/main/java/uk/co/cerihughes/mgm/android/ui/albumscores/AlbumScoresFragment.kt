package uk.co.cerihughes.mgm.android.ui.albumscores

import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v4.app.LoaderManager
import android.support.v4.content.Loader
import android.support.v7.widget.DividerItemDecoration
import android.support.v7.widget.LinearLayoutManager
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import kotlinx.android.synthetic.main.fragment_album_scores.view.*
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.dataloader.AsyncTaskEventLoader
import uk.co.cerihughes.mgm.android.model.Event

class AlbumScoresFragment : Fragment(), LoaderManager.LoaderCallbacks<List<Event>> {

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        val activity = activity ?: return null

        val fragmentView = inflater.inflate(R.layout.fragment_album_scores, container, false)

        val layoutManager = LinearLayoutManager(activity, LinearLayoutManager.VERTICAL, false)
        val dividerItemDecoration = DividerItemDecoration(activity, layoutManager.orientation)
        fragmentView.recycler_view.layoutManager = layoutManager
        fragmentView.recycler_view.addItemDecoration(dividerItemDecoration)

        return fragmentView
    }

    override fun onStart() {
        super.onStart()

        loaderManager.initLoader(AsyncTaskEventLoader.EVENT_LOADER_ID, null, this)
    }

    override fun onCreateLoader(id: Int, args: Bundle?): Loader<List<Event>> {
        return AsyncTaskEventLoader(activity!!)
    }

    override fun onLoadFinished(loader: Loader<List<Event>>, events: List<Event>?) {
        val view = view ?: return
        val events = events ?: return

        val viewModel = AlbumScoresViewModelImpl(events)
        view.recycler_view.adapter = AlbumScoresAdapter(viewModel)
    }

    override fun onLoaderReset(events: Loader<List<Event>>) {
    }
}
