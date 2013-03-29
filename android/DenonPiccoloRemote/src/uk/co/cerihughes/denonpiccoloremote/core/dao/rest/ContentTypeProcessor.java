package uk.co.cerihughes.denonpiccoloremote.core.dao.rest;

public interface ContentTypeProcessor<ResponseType>
{
	ResponseType processResponse(String response) throws ContentTypeProcessorException;
}
