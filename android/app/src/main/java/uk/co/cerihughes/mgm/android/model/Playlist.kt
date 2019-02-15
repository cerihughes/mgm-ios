package uk.co.cerihughes.mgm.android.model

data class Playlist(val spotifyID: String?,
                    val name: String,
                    val owner: String,
                    val images: Array<Image>)