
package uk.co.cerihughes.denonpiccoloremote;

public class AsyncTaskResult<Result>
{
	private Result result;
	private Exception error;
	

	public AsyncTaskResult(Result result)
	{
		super();
		this.result = result;
	}

	public AsyncTaskResult(Exception error)
	{
		super();
		this.error = error;
	}

	public Result getResult()
	{
		return result;
	}

	public Exception getError()
	{
		return error;
	}

}