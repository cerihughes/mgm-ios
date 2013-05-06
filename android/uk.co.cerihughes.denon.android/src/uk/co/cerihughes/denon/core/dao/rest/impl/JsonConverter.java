package uk.co.cerihughes.denon.core.dao.rest.impl;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import android.annotation.SuppressLint;

public abstract class JsonConverter
{
	@SuppressLint("SimpleDateFormat")
	private SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");

	protected Date getDate(String jsonDate)
	{
		try
		{
			return formatter.parse(jsonDate);
		}
		catch (ParseException ex)
		{
			// TODO: LOG
			ex.printStackTrace();
			return null;
		}
	}
}
