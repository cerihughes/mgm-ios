package uk.co.cerihughes.mgm.android.ui.albumscores

import android.support.v7.widget.RecyclerView
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.model.Event

class AlbumScoresAdapter (private val events: Array<Event>) : RecyclerView.Adapter<AlbumScoresAdapter.AlbumScoresItemViewHolder>() {

    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): AlbumScoresItemViewHolder {
        val context = viewGroup.context
        val inflater = LayoutInflater.from(context)
        val view = inflater.inflate(R.layout.album_scores_list_item, viewGroup, false)
        return AlbumScoresItemViewHolder(view)
    }

    override fun onBindViewHolder(holder: AlbumScoresItemViewHolder, position: Int) {
    }

    override fun getItemCount(): Int {
        return events.size
    }

    class AlbumScoresItemViewHolder(val itemView: View) : RecyclerView.ViewHolder(itemView) {
    }
}
