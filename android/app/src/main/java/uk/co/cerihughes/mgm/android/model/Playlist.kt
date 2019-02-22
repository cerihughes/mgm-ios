package uk.co.cerihughes.mgm.android.model

data class Playlist(val spotifyId: String?,
                    val name: String,
                    val owner: String,
                    val images: List<Image>)