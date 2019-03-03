package uk.co.cerihughes.mgm.android.ui

import android.os.Bundle
import android.support.design.widget.BottomNavigationView
import android.support.v4.app.Fragment
import android.support.v7.app.AppCompatActivity
import android.view.MenuItem
import com.crashlytics.android.Crashlytics
import io.fabric.sdk.android.Fabric
import kotlinx.android.synthetic.main.activity_main.*
import org.koin.android.viewmodel.ext.android.viewModel
import uk.co.cerihughes.mgm.android.R
import uk.co.cerihughes.mgm.android.ui.albumscores.AlbumScoresFragment
import uk.co.cerihughes.mgm.android.ui.latestevent.LatestEventFragment

class MainActivity : AppCompatActivity() {

    val viewModel: MainViewModel by viewModel()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        Fabric.with(this, Crashlytics())

        setContentView(R.layout.activity_main)
        loadFragment(viewModel.selectedItemId)

        navigation.setOnNavigationItemSelectedListener(object: BottomNavigationView.OnNavigationItemSelectedListener {
            override fun onNavigationItemSelected(item: MenuItem): Boolean {
                return loadFragment(item.itemId)
            }
        })
    }

    private fun loadFragment(itemId: Int): Boolean {
        viewModel.selectedItemId = itemId

        when (itemId) {
            R.id.navigation_latest_event -> {
                loadFragment(LatestEventFragment())
                return true
            }
            R.id.navigation_album_scores -> {
                loadFragment(AlbumScoresFragment())
                return true
            }
        }
        return false
    }

    private fun loadFragment(fragment: Fragment) {
        supportFragmentManager
            .beginTransaction()
            .replace(R.id.fragment_container, fragment)
            .commit()
    }
}
