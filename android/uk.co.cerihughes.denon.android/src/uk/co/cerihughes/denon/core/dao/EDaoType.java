package uk.co.cerihughes.denon.core.dao;

public enum EDaoType
{
	PLAYER_DENON(false),

	LAST_FM_DIRECT(true),

	LAST_FM_DENON(false),

	SPOTIFY_DIRECT(true),

	SPOTIFY_DENON(false),

	DLNA_DIRECT(true),

	DLNA_DENON(false);

	private boolean direct;

	private EDaoType(boolean direct)
	{
		this.direct = direct;
	}

	public boolean isDirect()
	{
		return direct;
	}
}
