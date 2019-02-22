package uk.co.cerihughes.mgm.android.ui.albumscores

import android.content.Intent
import android.support.v4.content.res.ResourcesCompat
import android.support.v7.widget.RecyclerView
import android.view.View
import android.view.ViewGroup
import com.squareup.picasso.Picasso
import kotlinx.android.synthetic.main.album_scores_list_item.view.*
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.ui.inflate
import uk.co.cerihughes.mgm.android.ui.launchSpotify

class AlbumScoresAdapter (private val viewModel: AlbumScoresViewModel) : RecyclerView.Adapter<AlbumScoresAdapter.AlbumScoresItemViewHolder>() {

    override fun onCreateViewHolder(viewGroup: ViewGroup, viewType: Int): AlbumScoresItemViewHolder {
        val view = viewGroup.inflate(R.layout.album_scores_list_item, false)
        val holder = AlbumScoresItemViewHolder(viewModel, view)
        view.setOnClickListener(holder)
        return holder
    }

    override fun onBindViewHolder(holder: AlbumScoresItemViewHolder, index: Int) {
        val albumScoreViewModel = viewModel.scoreViewModel(index) ?: return
        holder.bind(albumScoreViewModel)
    }

    override fun getItemCount() = viewModel.numberOfScores()

    class AlbumScoresItemViewHolder(private val viewModel: AlbumScoresViewModel, itemView: View) : RecyclerView.ViewHolder(itemView), View.OnClickListener {

        fun bind(viewModel: AlbumScoreViewModel) {
            val largestDimension = itemView.resources.getDimension(R.dimen.album_scores_list_item_height)
            viewModel.coverArtURL(largestDimension.toInt())?.let {
                Picasso.get()
                    .load(it)
                    .placeholder(R.drawable.album1)
                    .into(itemView.coverArtIV)
            } ?: itemView.coverArtIV.setImageDrawable(ResourcesCompat.getDrawable(itemView.resources, R.drawable.album1, null))

            itemView.albumNameTV.text = viewModel.albumName()
            itemView.artistNameTV.text = viewModel.artistName()
            itemView.ratingTV.text = viewModel.rating()
            itemView.ratingTV.setTextColor(viewModel.ratingColour())
            itemView.positionTV.text = viewModel.position()

            itemView.awardIV.setImageDrawable(ResourcesCompat.getDrawable(itemView.resources, viewModel.awardImage(), null))
        }

        override fun onClick(v: View?) {
            var view = v ?: return
            var context = view.context

            if (viewModel.isSpotifyInstalled(context) == false) {
                return
            }

            val albumScoreViewModel = viewModel.scoreViewModel(adapterPosition) ?: return
            var spotifyURL = albumScoreViewModel.spotifyURL() ?: return

            val intent = Intent(Intent.ACTION_VIEW)
            intent.launchSpotify(context, spotifyURL)
        }
    }
}
