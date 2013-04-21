package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import junit.framework.Assert;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Before;
import org.junit.Test;

import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public class TestLastFmMobileSessionJsonConverter
{
	private static final String SINGLE_RESULT_JSON = "{\"session\":{\"name\":\"arkanoid\",\"key\":\"abcdefg\",\"subscriber\":\"0\"}}";

	private LastFmMobileSessionJsonConverter cut;

	@Before
	public void setUp()
	{
		cut = new LastFmMobileSessionJsonConverter();
	}

	@Test
	public void testSingleResult() throws ConverterException, JSONException
	{
		final JSONObject json = new JSONObject(SINGLE_RESULT_JSON);
		final String result = cut.convert(json);
		Assert.assertEquals("abcdefg", result);
	}
}
