package uk.co.cerihughes.denon.core.dao.rest;

public interface ResponseProcessor<ResponseType>
{
	ResponseType processResponse(String response) throws ResponseProcessorException;
}
