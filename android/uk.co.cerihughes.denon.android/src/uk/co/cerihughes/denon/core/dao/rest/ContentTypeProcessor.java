package uk.co.cerihughes.denon.core.dao.rest;

public interface ContentTypeProcessor<ResponseType>
{
	ResponseType processResponse(String response) throws ContentTypeProcessorException;
}
