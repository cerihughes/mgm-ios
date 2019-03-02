package uk.co.cerihughes.mgm.android.ui

import android.arch.lifecycle.ViewModel
import android.arch.lifecycle.ViewModelProvider
import uk.co.cerihughes.mgm.android.repository.RemoteDataSource
import uk.co.cerihughes.mgm.android.repository.RemoteDataSourceImpl
import uk.co.cerihughes.mgm.android.ui.albumscores.AlbumScoresViewModel
import uk.co.cerihughes.mgm.android.ui.latestevent.LatestEventViewModel

class ViewModelProviderFactory private constructor(private val remoteDataSource: RemoteDataSource): ViewModelProvider.Factory {

    override fun <T : ViewModel> create(modelClass: Class<T>) =
        with(modelClass) {
            when {
                isAssignableFrom(LatestEventViewModel::class.java) ->
                    LatestEventViewModel(remoteDataSource)
                isAssignableFrom(AlbumScoresViewModel::class.java) ->
                    AlbumScoresViewModel(remoteDataSource)
                else ->
                    throw IllegalArgumentException("Unknown ViewModel class: ${modelClass.name}")
            }
        } as T

    companion object {

        @Volatile
        private var INSTANCE: ViewModelProviderFactory? = null

        fun getInstance(): ViewModelProviderFactory {
            return INSTANCE ?: synchronized(ViewModelProviderFactory::class.java) {
                INSTANCE ?: ViewModelProviderFactory(RemoteDataSourceImpl())
                    .also { INSTANCE = it }
            }
        }
    }
}
