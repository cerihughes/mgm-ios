package uk.co.cerihughes.mgm.android

import org.koin.android.viewmodel.ext.koin.viewModel
import org.koin.dsl.module.module
import uk.co.cerihughes.mgm.android.repository.RemoteDataSource
import uk.co.cerihughes.mgm.android.repository.RemoteDataSourceImpl
import uk.co.cerihughes.mgm.android.ui.albumscores.AlbumScoresViewModel
import uk.co.cerihughes.mgm.android.ui.latestevent.LatestEventViewModel

val appModule = module {

    // single instance of RemoteDataSource
    single<RemoteDataSource> { RemoteDataSourceImpl() }

    viewModel { LatestEventViewModel(get()) }
    viewModel { AlbumScoresViewModel(get()) }
}
