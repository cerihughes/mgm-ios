package uk.co.cerihughes.mgm.android.di

import org.koin.android.ext.koin.androidContext
import org.koin.android.viewmodel.ext.koin.viewModel
import org.koin.dsl.module.module
import uk.co.cerihughes.mgm.android.repository.Repository
import uk.co.cerihughes.mgm.android.repository.RepositoryImpl
import uk.co.cerihughes.mgm.android.repository.local.LocalDataSource
import uk.co.cerihughes.mgm.android.repository.local.LocalDataSourceImpl
import uk.co.cerihughes.mgm.android.repository.remote.RemoteDataSource
import uk.co.cerihughes.mgm.android.repository.remote.RemoteDataSourceImpl
import uk.co.cerihughes.mgm.android.ui.MainViewModel
import uk.co.cerihughes.mgm.android.ui.albumscores.AlbumScoresViewModel
import uk.co.cerihughes.mgm.android.ui.latestevent.LatestEventViewModel

val appModule = module {

    // single instance of RemoteDataSource
    single<RemoteDataSource> { RemoteDataSourceImpl() }

    // single instance of LocalDataSource
    single<LocalDataSource> { LocalDataSourceImpl(androidContext()) }

    // single instance of Repository
    single<Repository> { RepositoryImpl(get(), get()) }

    viewModel { MainViewModel() }
    viewModel { LatestEventViewModel(get()) }
    viewModel { AlbumScoresViewModel(get()) }
}
