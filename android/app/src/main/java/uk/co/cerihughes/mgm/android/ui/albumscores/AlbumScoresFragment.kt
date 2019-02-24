package uk.co.cerihughes.mgm.android.ui.albumscores

import android.arch.lifecycle.ViewModelProviders
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

    lateinit var viewModel: AlbumScoresViewModel

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_album_scores, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        viewModel = ViewModelProviders.of(this).get(AlbumScoresViewModel::class.java)

        val recyclerView = view?.recycler_view ?: return
        val layoutManager = LinearLayoutManager(activity, LinearLayoutManager.VERTICAL, false)
        val dividerItemDecoration = DividerItemDecoration(activity, layoutManager.orientation)
        recyclerView.layoutManager = layoutManager
        recyclerView.addItemDecoration(dividerItemDecoration)
        recyclerView.adapter = AlbumScoresAdapter(viewModel)
    }

    override fun onStart() {
        super.onStart()

        if (viewModel.isLoaded()) {
            return
        }

        val progressBar = view?.progress_loader ?: return
        progressBar.visibility = View.VISIBLE

        loaderManager.initLoader(AsyncTaskEventLoader.EVENT_LOADER_ID, null, this)
    }

    override fun onCreateLoader(id: Int, args: Bundle?): Loader<List<Event>> {
        return AsyncTaskEventLoader(activity!!)
    }

    override fun onLoadFinished(loader: Loader<List<Event>>, events: List<Event>?) {
        val recyclerView = view?.recycler_view ?: return
        val progressBar = view?.progress_loader ?: return
        val events = events ?: return

        progressBar.visibility = View.GONE

        viewModel.setEvents(events)
        recyclerView.adapter?.notifyDataSetChanged()
    }

    override fun onLoaderReset(events: Loader<List<Event>>) {
    }
}
