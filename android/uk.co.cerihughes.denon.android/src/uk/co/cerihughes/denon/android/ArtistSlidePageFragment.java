package uk.co.cerihughes.denon.android;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class ArtistSlidePageFragment extends Fragment
{
	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
	{
		// Inflate the layout containing a title and body text.
		ViewGroup rootView = (ViewGroup) inflater.inflate(R.layout.artists_slide_page, container, false);

		// Set the title view to show the page number.
		((TextView) rootView.findViewById(android.R.id.text1)).setText(getString(R.string.title_template_step));

		return rootView;
	}
}
