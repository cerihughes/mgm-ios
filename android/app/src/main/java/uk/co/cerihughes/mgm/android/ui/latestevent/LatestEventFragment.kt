package uk.co.cerihughes.mgm.android.ui.latestevent

import android.os.Bundle
import android.support.v4.app.Fragment
import android.support.v7.widget.DividerItemDecoration
import android.support.v7.widget.LinearLayoutManager
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import kotlinx.android.synthetic.main.fragment_album_scores.view.*
import org.koin.android.viewmodel.ext.android.sharedViewModel
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.ui.RemoteDataLoadingViewModel

class LatestEventFragment : Fragment() {

    val viewModel: LatestEventViewModel by sharedViewModel()

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        return inflater.inflate(R.layout.fragment_latest_event, container, false)
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)

        val recyclerView = view?.recycler_view ?: return
        val layoutManager = LinearLayoutManager(activity, LinearLayoutManager.VERTICAL, false)
        val dividerItemDecoration = DividerItemDecoration(activity, layoutManager.orientation)
        recyclerView.layoutManager = layoutManager
        recyclerView.addItemDecoration(dividerItemDecoration)
        recyclerView.adapter = LatestEventAdapter(viewModel)
    }

    override fun onStart() {
        super.onStart()

        if (viewModel.isLoaded()) {
            return
        }

        val progressBar = view?.progress_loader ?: return
        progressBar.visibility = View.VISIBLE

        viewModel.loadData(object: RemoteDataLoadingViewModel.LoadDataCallback {
            override fun onDataLoaded() {
                val recyclerView = view?.recycler_view ?: return

                progressBar.visibility = View.GONE
                recyclerView.adapter?.notifyDataSetChanged()
            }
        })
    }
}
