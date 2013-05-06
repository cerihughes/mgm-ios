package uk.co.cerihughes.denon.core.dao.impl.lastfm;

import uk.co.cerihughes.denon.core.dao.rest.RequestBodyGeneratorException;

public class LastFmMobileSessionAuthenticatorRequestBodyGenerator extends LastFmAuthenticatorRequestBodyGenerator
{
	private final String username;
	private final String password;

	public LastFmMobileSessionAuthenticatorRequestBodyGenerator(String secret, String username, String password)
	{
		super(secret);
		this.username = username;
		this.password = password;
	}

	@Override
	public String generateRequestBody() throws RequestBodyGeneratorException
	{
		final String passwordMd5 = md5(password);
		final String authToken = md5(username + passwordMd5);
		put("authToken", authToken);
		return super.generateRequestBody();
	}
}
