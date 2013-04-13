package uk.co.cerihughes.denon.core.dao;

import java.util.List;

import uk.co.cerihughes.denon.core.model.Service;

public interface IServicesDao extends IDao
{

	List<Service> services();

	Service getService(String name);
}
