package uk.co.cerihughes.denon.android;

import uk.co.cerihughes.denon.android.service.BrowserUpnpService;
import uk.co.cerihughes.denon.android.service.DlnaRegistryServiceConnection;
import uk.co.cerihughes.denonpiccoloremote.R;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.view.Menu;

public class MainActivity extends Activity
{
	private ServiceConnection serviceConnection = new DlnaRegistryServiceConnection();

	@Override
	public void onCreate(Bundle savedInstanceState)
	{
		super.onCreate(savedInstanceState);

		getApplicationContext().bindService(new Intent(this, BrowserUpnpService.class), serviceConnection, Context.BIND_AUTO_CREATE);

		setContentView(R.layout.activity_main);
		// DlnaArtistsTask task = new DlnaArtistsTask();
		// task.execute("");
	}

	@Override
	protected void onDestroy()
	{
		super.onDestroy();
		getApplicationContext().unbindService(serviceConnection);
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu)
	{
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
}
