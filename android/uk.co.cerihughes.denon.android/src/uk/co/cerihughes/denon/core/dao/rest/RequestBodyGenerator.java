package uk.co.cerihughes.denon.core.dao.rest;

public interface RequestBodyGenerator
{
	String generateRequestBody() throws RequestBodyGeneratorException;
}
