package uk.co.cerihughes.denonpiccoloremote.core.dao.rest;

public class RestServiceClient<ResponseType, ConvertedType>
{
	private Invoker invoker;
	private ContentTypeProcessor<ResponseType> processor;
	private Converter<ResponseType, ConvertedType> converter;

	public RestServiceClient(Invoker invoker, ContentTypeProcessor<ResponseType> processor, Converter<ResponseType, ConvertedType> converter)
	{
		this.invoker = invoker;
		this.processor = processor;
		this.converter = converter;
	}

	public ConvertedType invoke(String url) throws RestServiceClientException
	{
		try
		{
			final String response = invoker.invoke(url);
			final ResponseType processed = processor.processResponse(response);
			return converter.convert(processed);
		}
		catch (InvokerException ex)
		{
			throw new RestServiceClientException(ex);
		}
		catch (ContentTypeProcessorException ex)
		{
			throw new RestServiceClientException(ex);
		}
		catch (ConverterException ex)
		{
			throw new RestServiceClientException(ex);
		}
	}
}
