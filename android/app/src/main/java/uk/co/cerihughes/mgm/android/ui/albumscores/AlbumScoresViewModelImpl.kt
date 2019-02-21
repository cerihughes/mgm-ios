package uk.co.cerihughes.mgm.android.ui.albumscores

import uk.co.cerihughes.mgm.android.dataloader.DataLoader
import uk.co.cerihughes.mgm.android.model.Album

class AlbumScoresViewModelImpl(val dataLoader: DataLoader) : AlbumScoresViewModel {

    private var classicAlbums: List<Album> = emptyList()
    private var newAlbums: List<Album> = emptyList()
    private var allAlbums: List<Album> = emptyList()
    private var scoreViewModels: List<AlbumScoreViewModelImpl> = emptyList()

    override fun loadData() {
        val events = dataLoader.getEvents()
        classicAlbums = events.mapNotNull { it.classicAlbum }.filter { it.score != null }.sortedByDescending { it.score }
        newAlbums = events.mapNotNull { it.newAlbum }.filter { it.score != null }.sortedByDescending { it.score }
        allAlbums = (classicAlbums + newAlbums).sortedByDescending { it.score }
        scoreViewModels = allAlbums.mapIndexed { index, it -> AlbumScoreViewModelImpl(it, index) }
    }

    override fun numberOfScores(): Int {
        return scoreViewModels.size
    }

    override fun scoreViewModel(index: Int): AlbumScoreViewModelImpl? {
        try {
            return scoreViewModels[index]
        } catch (e: IndexOutOfBoundsException) {
            return null
        }
    }
}