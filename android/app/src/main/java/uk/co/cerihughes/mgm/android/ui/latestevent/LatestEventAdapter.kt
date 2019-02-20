package uk.co.cerihughes.mgm.android.ui.latestevent

import android.support.v4.content.res.ResourcesCompat
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.latest_event_entity_list_item.view.*
import kotlinx.android.synthetic.main.latest_event_location_list_item.view.*
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.ui.inflate

class LatestEventAdapter (private val viewModel: LatestEventViewModel) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    override fun getItemViewType(position: Int): Int {
        return viewModel.itemType(position).rawValue
    }

    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        when (viewType) {
            LatestEventViewModel.ItemType.LOCATION.rawValue -> {
                val view = viewGroup.inflate(R.layout.latest_event_location_list_item, false)
                return LatestEventLocationItemViewHolder(view)
            }
            else -> {
                val view = viewGroup.inflate(R.layout.latest_event_entity_list_item, false)
                return LatestEventEntityItemViewHolder(view)
            }
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (viewModel.itemType(position)) {
            LatestEventViewModel.ItemType.LOCATION -> {
                val holder = holder as? LatestEventLocationItemViewHolder ?: return
                holder.bind(viewModel)
            }
            LatestEventViewModel.ItemType.ENTITY -> {
                val holder = holder as? LatestEventEntityItemViewHolder ?: return
                val eventEntityViewModel = viewModel.eventEntityViewModel(position) ?: return
                holder.bind(eventEntityViewModel)
            }
        }
    }

    override fun getItemCount(): Int {
        var locationCount = if (viewModel.isLocationAvailable()) 1 else 0
        return locationCount + viewModel.numberOfEntites()
    }

    class LatestEventLocationItemViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        fun bind(viewModel: LatestEventViewModel) {
            itemView.locationTV.text = viewModel.locationName()
        }
    }

    class LatestEventEntityItemViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        fun bind(viewModel: LatestEventEntityViewModel) {
            val largestDimension = itemView.resources.getDimension(R.dimen.latest_event_entity_list_item_height)
            viewModel.coverArtURL(largestDimension.toInt())?.let {
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