package uk.co.cerihughes.denon.core.dao.rest;

public class RestServiceClientException extends Exception
{
	/** Generated */
	private static final long serialVersionUID = 2783482663371053295L;

	public RestServiceClientException(String detailMessage, Throwable throwable)
	{
		super(detailMessage, throwable);
	}

	public RestServiceClientException(String detailMessage)
	{
		super(detailMessage);
	}

	public RestServiceClientException(Throwable throwable)
	{
		super(throwable);
	}

}
