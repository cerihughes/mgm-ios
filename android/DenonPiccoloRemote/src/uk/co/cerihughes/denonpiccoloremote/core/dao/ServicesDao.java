package uk.co.cerihughes.denonpiccoloremote.core.dao;

import java.util.Collection;

import uk.co.cerihughes.denonpiccoloremote.core.model.Service;

public interface ServicesDao
{

	Collection<Service> services();

	Service getService(String name);
}
