package com.firebase.realtimeDB;

public class ErrandVO {
	private String mem_nickname;
	private double loc_x;
	private double loc_y;
	public ErrandVO() {
		
	}
	public ErrandVO(String mem_nickname, double loc_x, double loc_y) {
		this.mem_nickname = mem_nickname;
		this.loc_x = loc_x;
		this.loc_y = loc_y;
	}
	public String getMem_nickname() {
		return mem_nickname;
	}
	public void setMem_nickname(String mem_nickname) {
		this.mem_nickname = mem_nickname;
	}
	public double getLoc_x() {
		return loc_x;
	}
	public void setLoc_x(double loc_x) {
		this.loc_x = loc_x;
	}
	public double getLoc_y() {
		return loc_y;
	}
	public void setLoc_y(double loc_y) {
		this.loc_y = loc_y;
	}
	
}
