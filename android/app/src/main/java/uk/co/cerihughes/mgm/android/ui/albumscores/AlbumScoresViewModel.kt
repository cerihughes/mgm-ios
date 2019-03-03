package uk.co.cerihughes.mgm.android.ui.albumscores

import uk.co.cerihughes.mgm.android.model.Album
import uk.co.cerihughes.mgm.android.model.Event
import uk.co.cerihughes.mgm.android.repository.Repository
import uk.co.cerihughes.mgm.android.ui.RemoteDataLoadingViewModel

class AlbumScoresViewModel(repository: Repository) : RemoteDataLoadingViewModel(repository) {

    private val comparator = compareByDescending<Album> { it.score }
        .thenBy { it.name.toLowerCase() }
        .thenBy { it.artist.toLowerCase() }

    private var classicAlbums: List<Album> = emptyList()
    private var newAlbums: List<Album> = emptyList()
    private var allAlbums: List<Album> = emptyList()
    private var scoreViewModels: List<AlbumScoreViewModel> = emptyList()

    fun isLoaded(): Boolean = allAlbums.size > 0

    override fun setEvents(events: List<Event>) {
        classicAlbums = events.mapNotNull { it.classicAlbum }
            .filter { it.score != null }
            .sortedWith(comparator)

        newAlbums = events.mapNotNull { it.newAlbum }
            .filter { it.score != null }
            .sortedWith(comparator)

        allAlbums = (classicAlbums + newAlbums).sortedWith(comparator)

        val positions = calculatePositions(allAlbums)
        scoreViewModels = allAlbums.mapIndexed { index, it -> AlbumScoreViewModel(it, index, positions.get(index)) }
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

    private fun calculatePositions(albums: List<Album>): List<String> {
        val scores = albums.map { it.score ?: 0.0f }
        var positions: MutableList<String> = mutableListOf()
        var currentPosition = 0
        var currentValue = 11.0f
        for ((index, value) in scores.iterator().withIndex()) {
            if (value != currentValue) {
                currentValue = value
                currentPosition = index + 1
            }
            positions.add("$currentPosition")
        }
        return positions
    }
}