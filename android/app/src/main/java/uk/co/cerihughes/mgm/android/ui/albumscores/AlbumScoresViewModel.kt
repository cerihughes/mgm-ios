package uk.co.cerihughes.mgm.android.ui.albumscores

import uk.co.cerihughes.mgm.android.dataloader.DataLoader
import uk.co.cerihughes.mgm.android.model.Album
import java.lang.IndexOutOfBoundsException

class AlbumScoresViewModel(val dataLoader: DataLoader) {

    private var classicAlbums: List<Album>
    private var newAlbums: List<Album>
    private var allAlbums: List<Album>
    private var scoreViewModels: List<AlbumScoreViewModel>

    init {
        val events = dataLoader.getEvents()
        classicAlbums = events.mapNotNull { it.classicAlbum }.filter { it.score != null }.sortedByDescending { it.score }
        newAlbums = events.mapNotNull { it.newAlbum }.filter { it.score != null }.sortedByDescending { it.score }
        allAlbums = (classicAlbums + newAlbums).sortedByDescending { it.score }
        scoreViewModels = allAlbums.mapIndexed { index, it -> AlbumScoreViewModel(it, index) }
    }

    fun numberOfScores(): Int {
        return scoreViewModels.size
    }

    fun scoreViewModel(index: Int): AlbumScoreViewModel? {
        try {
            return scoreViewModels[index]
        } catch (e: IndexOutOfBoundsException) {
            return null
        }
    }
}