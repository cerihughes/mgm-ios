package uk.co.cerihughes.mgm.android.ui.latestevent

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

class LatestEventFragment : Fragment(), LoaderManager.LoaderCallbacks<List<Event>> {

    var viewModel: LatestEventViewModel? = null

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_latest_event, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val viewModel = ViewModelProviders.of(this).get(LatestEventViewModel::class.java)

        val recyclerView = view?.recycler_view ?: return
        val layoutManager = LinearLayoutManager(activity, LinearLayoutManager.VERTICAL, false)
        val dividerItemDecoration = DividerItemDecoration(activity, layoutManager.orientation)
        recyclerView.layoutManager = layoutManager
        recyclerView.addItemDecoration(dividerItemDecoration)
        recyclerView.adapter = LatestEventAdapter(viewModel)

        this.viewModel = viewModel
    }

    override fun onStart() {
        super.onStart()

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
        val viewModel = viewModel ?: return
        val events = events ?: return

        progressBar.visibility = View.GONE

        viewModel.setEvents(events)
        recyclerView.adapter?.notifyDataSetChanged()
    }

    override fun onLoaderReset(events: Loader<List<Event>>) {
    }
}
