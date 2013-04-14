package uk.co.cerihughes.denon.android;

public interface AsyncCallback<Result, Failure extends Throwable>
{
	void callbackSuccess(Result result);

	void callbackFailure(Failure failure);

	void callbackRuntimeException(RuntimeException rex);
}
