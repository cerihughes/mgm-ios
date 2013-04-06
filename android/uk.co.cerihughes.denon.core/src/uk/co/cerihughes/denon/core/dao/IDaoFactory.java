package uk.co.cerihughes.denon.core.dao;

public interface IDaoFactory extends ILifecycle
{
	void addListener(IDaoFactoryListener listener);

	void removeListener(IDaoFactoryListener listener);
}
