package uk.co.cerihughes.denonpiccoloremote.core.dao.impl;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Comparator;
import java.util.TreeMap;

import uk.co.cerihughes.denonpiccoloremote.core.dao.DaoException;

public class LastFmAuthenticatorHelper
{
	private String secret;
	private TreeMap<String, String> treeMap = new TreeMap<String, String>(new StringComparator());

	public LastFmAuthenticatorHelper(String secret)
	{
		this.secret = secret;
	}

	public String put(String key, String value)
	{
		return treeMap.put(key, value);
	}

	public String createBody() throws DaoException
	{
		final StringBuilder signature = new StringBuilder();
		final StringBuilder body = new StringBuilder();

		for (String key : treeMap.keySet())
		{
			body.append(key);
			body.append("=");
			body.append(treeMap.get(key));
			body.append("&");

			signature.append(key);
			signature.append(treeMap.get(key));
		}

		signature.append(secret);
		try
		{
			final MessageDigest digest = MessageDigest.getInstance("MD5");
			final byte[] bytes = digest.digest(signature.toString().getBytes());
			final String md5 = encodeHex(bytes);
			body.append("api_sig=");
			body.append(md5);
			return body.toString();
		}
		catch (NoSuchAlgorithmException ex)
		{
			throw new DaoException(ex);
		}
	}

	private String encodeHex(byte[] data)
	{
		final StringBuilder sb = new StringBuilder();
		for (byte b : data)
		{
			sb.append(String.format("%02x", b & 0xff));
		}
		return sb.toString();
	}

	private class StringComparator implements Comparator<String>
	{
		public int compare(String a, String b)
		{
			return a.compareTo(b);
		}
	}
}
