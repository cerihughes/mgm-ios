package uk.co.cerihughes.denon.core.player.rx;

import java.io.IOException;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;

import uk.co.cerihughes.denon.core.dao.impl.IConverter;
import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public class GetVolumeLevelRxConverter extends RxXmlConverter implements IConverter<XmlPullParser, Integer>
{
	private static final String DISPLAY_VALUE_TAG = "dispvalue";

	private String value;

	@Override
	public Integer convert(XmlPullParser parser) throws ConverterException
	{
		try
		{
			while (parser.next() != XmlPullParser.END_TAG)
			{
				if (parser.getEventType() != XmlPullParser.START_TAG)
				{
					continue;
				}
				String name = parser.getName();
				if (name.equals(DISPLAY_VALUE_TAG))
				{
					value = readTextWithinTag(parser, DISPLAY_VALUE_TAG);
				}
				else
				{
					skip(parser);
				}
			}
			if (value != null)
			{
				try
				{
					return Integer.parseInt(value);
				}
				catch (NumberFormatException ex)
				{
					throw new ConverterException(ex);
				}
			}
			return 0;
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
