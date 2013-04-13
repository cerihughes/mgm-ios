package uk.co.cerihughes.denon.core.dao;

public interface IDaoFactoryListener
{
	void daoAdded(IDao dao);

	void daoRemoved(IDao dao);
}
