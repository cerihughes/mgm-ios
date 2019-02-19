package uk.co.cerihughes.mgm.android.ui.latestevent

import android.support.v4.content.res.ResourcesCompat
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.latest_event_entity_list_item.view.*
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.ui.inflate

class LatestEventAdapter (private val viewModel: LatestEventViewModel) : RecyclerView.Adapter<LatestEventAdapter.LatestEventItemViewHolder>() {

    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): LatestEventItemViewHolder {
        val view = viewGroup.inflate(R.layout.latest_event_entity_list_item, false)
        return LatestEventItemViewHolder(view)
    }

    override fun onBindViewHolder(holder: LatestEventItemViewHolder, index: Int) {
        val eventEntityViewModel = viewModel.eventEntityViewModel(index) ?: return
        holder.bind(eventEntityViewModel)
    }

    override fun getItemCount(): Int {
        return viewModel.numberOfEntites()
    }

    class LatestEventItemViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind(viewModel: LatestEventEntityViewModel) {
            viewModel.coverArtURL(itemView.coverArtIV.width)?.let {
                Picasso.get()
                    .load(it)
                    .placeholder(R.drawable.album1)
                    .into(itemView.coverArtIV)
            } ?: itemView.coverArtIV.setImageDrawable(ResourcesCompat.getDrawable(itemView.resources, R.drawable.album1, null))

            itemView.entityTypeTV.text = viewModel.entityType
            itemView.albumNameTV.text = viewModel.entityName
            itemView.artistNameTV.text = viewModel.entityOwner
        }
    }
}