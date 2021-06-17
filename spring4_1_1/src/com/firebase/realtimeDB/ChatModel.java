package com.firebase.realtimeDB;

import java.util.HashMap;
import java.util.Map;

public class ChatModel {
	public Map<String,Boolean> users = new HashMap<>();
	public Map<String,Comment> comments = new HashMap<>();
	public static class Comment
	{
		public String uid;
		public String message;
		public Object timestamp;
		public Comment() {}
		public Comment(String uid, String message, Object timestamp) {
			super();
			this.uid = uid;
			this.message = message;
			this.timestamp = timestamp;
		}
		public String getUid() {
			return uid;
		}
		public void setUid(String uid) {
			this.uid = uid;
		}
		public String getMessage() {
			return message;
		}
		public void setMessage(String message) {
			this.message = message;
		}
		public Object getTimestamp() {
			return timestamp;
		}
		public void setTimestamp(Object timestamp) {
			this.timestamp = timestamp;
		}
	}
}
