package uk.co.cerihughes.denonpiccoloremote.core.dao;

public class DaoException extends Exception {

	/** Generated */
	private static final long serialVersionUID = 8392872281375497471L;

	public DaoException(String detailMessage, Throwable throwable) {
		super(detailMessage, throwable);
	}

	public DaoException(String detailMessage) {
		super(detailMessage);
	}

	public DaoException(Throwable throwable) {
		super(throwable);
	}

}
