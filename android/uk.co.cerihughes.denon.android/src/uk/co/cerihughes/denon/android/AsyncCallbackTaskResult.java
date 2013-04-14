package uk.co.cerihughes.denon.android;

public class AsyncCallbackTaskResult<Result, Failure extends Throwable>
{
	private Result result;
	private Failure failure;
	private RuntimeException runtimeException;

	public Result getResult()
	{
		return result;
	}

	public void setResult(Result result)
	{
		this.result = result;
	}

	public Failure getFailure()
	{
		return failure;
	}

	public void setFailure(Failure failure)
	{
		this.failure = failure;
	}

	public RuntimeException getRuntimeException()
	{
		return runtimeException;
	}

	public void setRuntimeException(RuntimeException runtimeException)
	{
		this.runtimeException = runtimeException;
	}

}