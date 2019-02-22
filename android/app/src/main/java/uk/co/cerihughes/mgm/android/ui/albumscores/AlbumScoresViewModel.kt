package uk.co.cerihughes.mgm.android.ui.albumscores

import uk.co.cerihughes.mgm.android.ui.SpotifyAwareViewModel

interface AlbumScoresViewModel: SpotifyAwareViewModel {

    fun numberOfScores(): Int

    fun scoreViewModel(index: Int): AlbumScoreViewModelImpl?
}