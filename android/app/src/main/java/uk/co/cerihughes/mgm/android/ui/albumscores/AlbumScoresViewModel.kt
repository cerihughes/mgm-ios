package uk.co.cerihughes.mgm.android.ui.albumscores

import uk.co.cerihughes.mgm.android.model.Album
import uk.co.cerihughes.mgm.android.model.Event
import uk.co.cerihughes.mgm.android.ui.SpotifyAwareViewModel

class AlbumScoresViewModel : SpotifyAwareViewModel() {

    private var classicAlbums: List<Album> = emptyList()
    private var newAlbums: List<Album> = emptyList()
    private var allAlbums: List<Album> = emptyList()
    private var scoreViewModels: List<AlbumScoreViewModel> = emptyList()

    fun isLoaded(): Boolean = allAlbums.size > 0

    fun setEvents(events: List<Event>) {
        val comparator = compareByDescending<Album> { it.score }
            .thenBy { it.name }
            .thenBy { it.artist }

        classicAlbums = events.mapNotNull { it.classicAlbum }
            .filter { it.score != null }
            .sortedWith(comparator)

        newAlbums = events.mapNotNull { it.newAlbum }
            .filter { it.score != null }
            .sortedWith(comparator)

        allAlbums = (classicAlbums + newAlbums).sortedWith(comparator)
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