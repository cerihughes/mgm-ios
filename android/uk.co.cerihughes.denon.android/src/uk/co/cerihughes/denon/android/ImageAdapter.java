/*
 * Copyright (C) 2010 The Android Open Source Project
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package uk.co.cerihughes.denon.android;

import uk.co.cerihughes.denon.core.model.MusicItem;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

public class ImageAdapter extends BaseAdapter
{
	private MusicItem[] items;
	private final ImageDownloader imageDownloader = new ImageDownloader();

	public ImageAdapter(MusicItem[] items)
	{
		this.items = items;
	}

	public int getCount()
	{
		return items.length;
	}

	public String getItem(int position)
	{
		return items[position].getImageUri();
	}

	public long getItemId(int position)
	{
		return getItem(position).hashCode();
	}

	public View getView(int position, View view, ViewGroup parent)
	{
		if (view == null)
		{
			final LayoutInflater inflater = LayoutInflater.from(parent.getContext());
			view = inflater.inflate(R.layout.list_item, null);
		}

		final MusicItem item = items[position];
		final ImageView imageView = (ImageView) view.findViewById(R.id.image_view);
		imageDownloader.download(item.getImageUri(), imageView);

		final TextView textView = (TextView) view.findViewById(R.id.text_view);
		textView.setText(item.getName());

		return view;
	}

	public ImageDownloader getImageDownloader()
	{
		return imageDownloader;
	}
}
