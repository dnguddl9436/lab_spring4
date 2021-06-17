package com.firebase.realtimeDB;

public class User {
	public String name			= "";
	public String email		= "";
	public String nickname		= "";
	public String pushToken	= "";
	public User() {}
	public User(String name, String email, String nickname, String pushToken) {
		super();
		this.name = name;
		this.email = email;
		this.nickname = nickname;
		this.pushToken = pushToken;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getPushToken() {
		return pushToken;
	}
	public void setPushToken(String pushToken) {
		this.pushToken = pushToken;
	}
}
