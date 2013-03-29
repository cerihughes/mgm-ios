package uk.co.cerihughes.denonpiccoloremote.core.dao.rest.impl;

public enum LastFmImageSize
{
	SMALL("small"), MEDIUM("medium"), LARGE("large"), EXTRA_LARGE("extralarge"), MEGA("mega");

	private String jsonValue;

	private LastFmImageSize(String jsonValue)
	{
		this.jsonValue = jsonValue;
	}

	public String getJsonValue()
	{
		return jsonValue;
	}
}
