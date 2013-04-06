package uk.co.cerihughes.denon.core.dao;

import java.util.Collection;

import uk.co.cerihughes.denon.core.model.Service;

public interface IServicesDao extends IDao
{

	Collection<Service> services();

	Service getService(String name);
}
