package uk.co.cerihughes.mgm.android.ui.albumscores

interface AlbumScoresViewModel {
    fun loadData()

    fun numberOfScores(): Int

    fun scoreViewModel(index: Int): AlbumScoreViewModelImpl?
}