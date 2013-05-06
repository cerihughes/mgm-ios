package uk.co.cerihughes.denon.core.player;

import java.util.ArrayList;

import uk.co.cerihughes.denon.core.dao.rest.RequestBodyGenerator;

public class TxBodyGenerator implements RequestBodyGenerator
{
	private static final String NEWLINE = "\r\n";
	private static final String OPEN_TX = "<tx>" + NEWLINE;
	private static final String OPEN_CMD = " <cmd id=\"1\">";
	private static final String CLOSE_CMD = "</cmd>" + NEWLINE;
	private static final String CLOSE_TX = "</tx>" + NEWLINE;
	private final ArrayList<String> list = new ArrayList<String>();

	public void addCommand(String command)
	{
		list.add(command);
	}

	@Override
	public String generateRequestBody()
	{
		final StringBuilder sb = new StringBuilder();
		sb.append(OPEN_TX);
		for (String key : list)
		{
			sb.append(OPEN_CMD);
			sb.append(key);
			sb.append(CLOSE_CMD);
		}
		sb.append(CLOSE_TX);
		return sb.toString();
	}
}
