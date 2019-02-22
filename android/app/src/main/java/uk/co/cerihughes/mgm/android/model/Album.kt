package uk.co.cerihughes.mgm.android.model

data class Album(val type: AlbumType?,
                 val spotifyId: String?,
                 val name: String,
                 val artist: String,
                 val score: Float?,
                 val images: List<Image>)
