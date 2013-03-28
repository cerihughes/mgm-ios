package uk.co.cerihughes.denonpiccoloremote.core.dao.rest;

public class RestServiceClient<ResponseType, ConvertedType> {

	private Getter<ResponseType> getter;
	private Converter<ResponseType, ConvertedType> converter;

	public RestServiceClient(Getter<ResponseType> getter,
			Converter<ResponseType, ConvertedType> converter) {
		this.getter = getter;
		this.converter = converter;
	}

	public ConvertedType get(String url) throws GetterException,
			ConvertException {
		ResponseType response = getter.get(url);
		return converter.convert(response);
	}
}
