package uk.co.cerihughes.denon.core.dao.rest;

public class ResponseProcessorException extends Exception
{
	/** Generated */
	private static final long serialVersionUID = 1932254749284013212L;

	public ResponseProcessorException(String detailMessage, Throwable throwable)
	{
		super(detailMessage, throwable);
	}

	public ResponseProcessorException(String detailMessage)
	{
		super(detailMessage);
	}

	public ResponseProcessorException(Throwable throwable)
	{
		super(throwable);
	}

}
