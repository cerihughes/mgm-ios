package uk.co.cerihughes.denonpiccoloremote.core.dao.rest;

public class InvokerException extends Exception
{
	/** Generated */
	private static final long serialVersionUID = 2077605944011985421L;

	public InvokerException(String detailMessage, Throwable throwable)
	{
		super(detailMessage, throwable);
	}

	public InvokerException(String detailMessage)
	{
		super(detailMessage);
	}

	public InvokerException(Throwable throwable)
	{
		super(throwable);
	}

}
