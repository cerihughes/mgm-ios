package uk.co.cerihughes.denon.core.model;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

public class EHTObject
{
	@Override
	public boolean equals(Object object)
	{
		// TODO Auto-generated method stub
		return super.equals(object);
	}

	@Override
	public int hashCode()
	{
		// TODO Auto-generated method stub
		return super.hashCode();
	}

	@Override
	public String toString()
	{
		final Map<String, Object> map = new HashMap<String, Object>();
		Class<?> clazz = getClass();
		while (clazz != null)
		{
			final Method[] methods = clazz.getMethods();
			for (Method method : methods)
			{
				final EHT annotation = method.getAnnotation(EHT.class);
				if (annotation != null)
				{
					final String name = annotation.field();
					Object value = "Cannot access value";

					try
					{
						value = method.invoke(this, new Object[] {});
					}
					catch (IllegalAccessException e)
					{
					}
					catch (IllegalArgumentException e)
					{
					}
					catch (InvocationTargetException e)
					{
					}

					map.put(name, value);
				}
			}
			clazz = clazz.getSuperclass();
		}
		return map.toString();
	}

}
