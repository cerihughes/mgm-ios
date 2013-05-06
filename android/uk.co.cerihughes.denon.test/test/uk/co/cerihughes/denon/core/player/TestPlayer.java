package uk.co.cerihughes.denon.core.player;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import uk.co.cerihughes.denon.core.dao.DaoException;

import com.xtremelabs.robolectric.Robolectric;
import com.xtremelabs.robolectric.RobolectricTestRunner;

@RunWith(RobolectricTestRunner.class)
public class TestPlayer
{
	private Player cut;

	@Before
	public void setUp()
	{
		cut = new Player("192.168.0.104");
	}

	@Test
	public void testGetVolume() throws DaoException
	{
		final String response = "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\r\n<rx>\r\n    <cmd>\r\n        <zone1>STANDBY</zone1>\r\n    </cmd>\r\n    <cmd>\r\n        <volume>-66.0</volume>\r\n       \r\n<disptype>ABSOLUTE</disptype>\r\n        <dispvalue>14</dispvalue>\r\n    </cmd>\r\n    <cmd>\r\n        <mute>off</mute>\r\n    </cmd>\r\n    <cmd>\r\n        <surround></surround>\r\n    </cmd>\r\n    <cmd>\r\n        <source>Music Server</source>\r\n    </cmd>\r\n</rx>\r\n";
		Robolectric.addPendingHttpResponse(200, response);
		final int volume = cut.getVolume();
		System.out.println(volume);
	}

}
