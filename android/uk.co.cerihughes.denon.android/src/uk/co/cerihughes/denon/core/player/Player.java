package uk.co.cerihughes.denon.core.player;

import uk.co.cerihughes.denon.core.dao.DaoException;
import uk.co.cerihughes.denon.core.dao.EDaoType;
import uk.co.cerihughes.denon.core.dao.impl.RestServiceDao;
import uk.co.cerihughes.denon.core.dao.rest.VoidResponseConverter;
import uk.co.cerihughes.denon.core.dao.rest.impl.StringResponseProcessor;
import uk.co.cerihughes.denon.core.dao.rest.impl.XmlResponseProcessor;
import uk.co.cerihughes.denon.core.player.rx.GetVolumeLevelRxConverter;
import android.annotation.SuppressLint;

public class Player extends RestServiceDao
{
	private static final String GET_VOLUME_COMMAND = "GetVolumeLevel";

	private static final String GET_VOLUME_FORMAT = "http://%s/goform/AppCommand.xml";
	private static final String SET_VOLUME_FORMAT = "http://%s/goform/formiPhoneAppDirect.xml?MV%2d";
	private static final String DECREASE_VOLUME_FORMAT = "http://%s/goform/formiPhoneAppDirect.xml?MVDOWN";
	private static final String INCREASE_VOLUME_FORMAT = "http://%s/goform/formiPhoneAppDirect.xml?MVUP";

	private String address;

	public Player(String address)
	{
		super();
		this.address = address;
	}

	@SuppressLint("DefaultLocale")
	private String getGetVolumeUrl()
	{
		return String.format(GET_VOLUME_FORMAT, address);
	}

	@SuppressLint("DefaultLocale")
	private String getSetVolumeUrl(int volume)
	{
		return String.format(SET_VOLUME_FORMAT, address, volume);
	}

	@SuppressLint("DefaultLocale")
	private String getIncreaseVolumeUrl()
	{
		return String.format(INCREASE_VOLUME_FORMAT, address);
	}

	@SuppressLint("DefaultLocale")
	private String getDecreaseVolumeUrl()
	{
		return String.format(DECREASE_VOLUME_FORMAT, address);
	}

	@Override
	public EDaoType getType()
	{
		return EDaoType.PLAYER_DENON;
	}

	public int getVolume() throws DaoException
	{
		final String url = getGetVolumeUrl();
		final TxBodyGenerator bodyGenerator = new TxBodyGenerator();
		bodyGenerator.addCommand(GET_VOLUME_COMMAND);
		return post(url, bodyGenerator, new XmlResponseProcessor(), new GetVolumeLevelRxConverter());
	}

	public void setVolume(int volume) throws DaoException
	{
		final String url = getSetVolumeUrl(volume);
		get(url, TEXT_XML, new StringResponseProcessor(), new VoidResponseConverter());
	}

	public void increaseVolume() throws DaoException
	{
		final String url = getIncreaseVolumeUrl();
		get(url, TEXT_XML, new StringResponseProcessor(), new VoidResponseConverter());
	}

	public void decreaseVolume() throws DaoException
	{
		final String url = getDecreaseVolumeUrl();
		get(url, TEXT_XML, new StringResponseProcessor(), new VoidResponseConverter());
	}
}
