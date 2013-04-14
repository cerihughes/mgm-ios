package uk.co.cerihughes.denon.android;

import android.os.AsyncTask;

public abstract class AsyncCallbackTask<Params, Progress, Result, Failure extends Throwable>
{
	public void execute(AsyncCallback<Result, Failure> callback, Params... params)
	{
		final Task task = new Task(callback);
		task.execute(params);
	}

	protected abstract Result runInBackground(Params... params) throws Failure;

	private class Task extends AsyncTask<Params, Progress, AsyncCallbackTaskResult<Result, Failure>>
	{
		private AsyncCallback<Result, Failure> callback;

		public Task(AsyncCallback<Result, Failure> callback)
		{
			super();
			this.callback = callback;
		}

		@SuppressWarnings("unchecked")
		@Override
		protected final AsyncCallbackTaskResult<Result, Failure> doInBackground(Params... params)
		{
			final AsyncCallbackTaskResult<Result, Failure> tr = new AsyncCallbackTaskResult<Result, Failure>();
			try
			{
				final Result result = runInBackground(params);
				tr.setResult(result);
			}
			catch (RuntimeException ex)
			{
				tr.setRuntimeException(ex);
			}
			catch (Throwable ex)
			{
				tr.setFailure((Failure) ex);
			}
			return tr;
		}

		@Override
		protected final void onPostExecute(AsyncCallbackTaskResult<Result, Failure> result)
		{
			final RuntimeException rex = result.getRuntimeException();
			if (rex != null)
			{
				callback.callbackRuntimeException(rex);
			}
			else
			{
				final Failure failure = result.getFailure();
				if (failure != null)
				{
					callback.callbackFailure(failure);
				}
				else
				{
					callback.callbackSuccess(result.getResult());
				}
			}
		}

	}
}
