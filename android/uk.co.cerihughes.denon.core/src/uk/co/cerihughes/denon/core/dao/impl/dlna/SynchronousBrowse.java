package uk.co.cerihughes.denon.core.dao.impl.dlna;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import org.teleal.cling.UpnpService;
import org.teleal.cling.model.action.ActionInvocation;
import org.teleal.cling.model.message.UpnpResponse;
import org.teleal.cling.model.meta.Service;
import org.teleal.cling.support.contentdirectory.callback.Browse;
import org.teleal.cling.support.model.BrowseFlag;
import org.teleal.cling.support.model.DIDLContent;

import uk.co.cerihughes.denon.core.dao.DaoException;

public class SynchronousBrowse
{
	private CountDownLatch countDownLatch = new CountDownLatch(1);;
	private DIDLContent success;
	private DaoException failure;

	public DIDLContent browse(UpnpService upnpService, Service<?, ?> service, String containerId, BrowseFlag flag, int timeoutInSeconds)
			throws DaoException
	{
		System.out.println(String.format("Browsing container %s", containerId));
		final AsynchronousBrowse browse = new AsynchronousBrowse(service, containerId, flag);
		upnpService.getControlPoint().execute(browse);
		try
		{
			countDownLatch.await(timeoutInSeconds, TimeUnit.SECONDS);
			if (success != null)
			{
				System.out.println(String.format("Container %s has %s items.", containerId, success.toString()));
				return success;
			}
			if (failure != null)
			{
				throw failure;
			}
			throw new DaoException("Operation timed out.");
		}
		catch (InterruptedException ex)
		{
			throw new DaoException(ex);
		}
	}

	private class AsynchronousBrowse extends Browse
	{
		public AsynchronousBrowse(Service<?,?> service, String containerId, BrowseFlag flag)
		{
			super(service, containerId, flag);
		}

		@Override
		public void received(ActionInvocation action, DIDLContent didl)
		{
			success = didl;
			countDownLatch.countDown();
		}

		@Override
		public void updateStatus(Status status)
		{
		}

		@Override
		public void failure(ActionInvocation action, UpnpResponse response, String message)
		{
			failure = new DaoException(String.format("Cannot browse DLNA server. Response [%s], message [%s].",
					response.getResponseDetails(), message));
			countDownLatch.countDown();
		}
	}
}
