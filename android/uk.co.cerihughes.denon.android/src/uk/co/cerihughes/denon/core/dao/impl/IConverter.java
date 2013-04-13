package uk.co.cerihughes.denon.core.dao.impl;

import uk.co.cerihughes.denon.core.dao.rest.ConverterException;

public interface IConverter<ResponseType, ConvertedType>
{
	ConvertedType convert(ResponseType response) throws ConverterException;
}
