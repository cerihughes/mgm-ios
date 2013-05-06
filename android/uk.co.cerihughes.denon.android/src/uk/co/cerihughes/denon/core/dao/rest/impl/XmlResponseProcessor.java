package uk.co.cerihughes.denon.core.dao.rest.impl;

import java.io.StringReader;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import uk.co.cerihughes.denon.core.dao.rest.ResponseProcessor;
import uk.co.cerihughes.denon.core.dao.rest.ResponseProcessorException;
import android.util.Xml;

public class XmlResponseProcessor implements ResponseProcessor<XmlPullParser>
{
	@Override
	public XmlPullParser processResponse(String response) throws ResponseProcessorException
	{
		final XmlPullParser parser = Xml.newPullParser();
		try
		{
			parser.setFeature(XmlPullParser.FEATURE_PROCESS_NAMESPACES, false);
			parser.setInput(new StringReader(response));
			return parser;
		}
		catch (XmlPullParserException ex)
		{
			throw new ResponseProcessorException(ex);
		}
	}
}
