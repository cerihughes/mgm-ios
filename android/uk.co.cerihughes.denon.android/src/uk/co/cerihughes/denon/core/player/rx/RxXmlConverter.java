package uk.co.cerihughes.denon.core.player.rx;

import java.io.IOException;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public abstract class RxXmlConverter
{
	protected static final String NS = null;

	protected String readTextWithinTag(XmlPullParser parser, String tag) throws ConverterException
	{
		try
		{
			parser.require(XmlPullParser.START_TAG, NS, tag);
			final String title = readText(parser);
			parser.require(XmlPullParser.END_TAG, NS, tag);
			return title;
		}
		catch (IOException ex)
		{
			throw new ConverterException(ex);
		}
		catch (XmlPullParserException ex)
		{
			throw new ConverterException(ex);
		}
	}

	protected String readText(XmlPullParser parser) throws ConverterException
	{
		try
		{
			String result = null;

			if (parser.next() == XmlPullParser.TEXT)
			{
				result = parser.getText();
				parser.nextTag();
			}
			return result;
		}
		catch (IOException ex)
		{
			throw new ConverterException(ex);
		}
		catch (XmlPullParserException ex)
		{
			throw new ConverterException(ex);
		}
	}

	protected void skip(XmlPullParser parser) throws ConverterException
	{
		try
		{
			if (parser.getEventType() != XmlPullParser.START_TAG)
			{
				throw new IllegalStateException();
			}
			int depth = 1;
			while (depth != 0)
			{
				switch (parser.next())
				{
				case XmlPullParser.END_TAG:
					depth--;
					break;
				case XmlPullParser.START_TAG:
					depth++;
					break;
				}
			}
		}
		catch (IOException ex)
		{
			throw new ConverterException(ex);
		}
		catch (XmlPullParserException ex)
		{
			throw new ConverterException(ex);
		}
	}
}
