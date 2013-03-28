package uk.co.cerihughes.denonpiccoloremote.core.dao.rest;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

public abstract class Getter<ResponseType> {

	public ResponseType get(String url) throws GetterException,
			ConvertException {
		String response = getStringResponse(url);
		return convertStringResponse(response);
	}

	protected abstract ResponseType convertStringResponse(String response)
			throws ConvertException;

	private String getStringResponse(String url) throws GetterException {
		StringBuilder builder = new StringBuilder();
		HttpClient client = new DefaultHttpClient();
		HttpGet httpGet = new HttpGet(url);

		String accept = getAccept();
		if (accept != null) {
			httpGet.addHeader("Accept", accept);
		}
		try {
			HttpResponse response = client.execute(httpGet);
			StatusLine statusLine = response.getStatusLine();
			int statusCode = statusLine.getStatusCode();
			if (statusCode == 200) {
				HttpEntity entity = response.getEntity();
				InputStream content = entity.getContent();
				BufferedReader reader = new BufferedReader(
						new InputStreamReader(content));
				String line;
				while ((line = reader.readLine()) != null) {
					builder.append(line);
				}
			} else {
				throw new GetterException(String.format(
						"Unexpected response [%d] for url [%s].", statusCode,
						url));
			}
		} catch (ClientProtocolException ex) {
			throw new GetterException(ex);
		} catch (IOException ex) {
			throw new GetterException(ex);
		}
		return builder.toString();
	}

	public String getAccept() {
		return null;
	}
}
