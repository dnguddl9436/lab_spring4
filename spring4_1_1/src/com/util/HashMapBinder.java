package com.util;

import java.util.Enumeration;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

public class HashMapBinder {
	Logger logger = Logger.getLogger(HashMapBinder.class);
	HttpServletRequest request = null;
	public HashMapBinder() {}
	public HashMapBinder(HttpServletRequest request) {
		this.request = request;
	}
	public void bind(Map<String,Object> target) {
		Enumeration en = request.getParameterNames();
		//<input type="text" name="mem_id" 
		while(en.hasMoreElements()) {
			String key = (String)en.nextElement();
			logger.info("value:"+request.getParameter(key));
			target.put(key, HangulConversion.toUTF(request.getParameter(key)));
			logger.info("value:"+target);
		}
	}///////end of bind
}