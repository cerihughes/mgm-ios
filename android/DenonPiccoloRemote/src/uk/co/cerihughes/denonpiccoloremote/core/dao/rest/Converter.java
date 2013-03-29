package uk.co.cerihughes.denonpiccoloremote.core.dao.rest;

public interface Converter<ResponseType, ConvertedType>
{
	ConvertedType convert(ResponseType response) throws ConverterException;
}
