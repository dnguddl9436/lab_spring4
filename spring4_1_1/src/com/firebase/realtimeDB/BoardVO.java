package com.firebase.realtimeDB;

public class BoardVO {
	private int 	bm_no		= 0;
	private String 	bm_title	= "";
	private int 	bm_hit		= 0;
	private String 	bm_date		= "";
	private int 	bm_like		= 0;
	private String 	bm_content	= "";
	private int 	bm_price	= 0;
	private boolean bm_isSold	= false;
	private String	mem_email	= "";
	private int		category_no	= 0;

	public BoardVO(int bm_no, String bm_title, int bm_hit, String bm_date, int bm_like, String bm_content, int bm_price,
			boolean bm_isSold, String mem_email, int category_no) {
		this.bm_no = bm_no;
		this.bm_title = bm_title;
		this.bm_hit = bm_hit;
		this.bm_date = bm_date;
		this.bm_like = bm_like;
		this.bm_content = bm_content;
		this.bm_price = bm_price;
		this.bm_isSold = bm_isSold;
		this.mem_email = mem_email;
		this.category_no = category_no;
	}
	public int getBm_no() {
		return bm_no;
	}
	public void setBm_no(int bm_no) {
		this.bm_no = bm_no;
	}
	public String getBm_title() {
		return bm_title;
	}
	public void setBm_title(String bm_title) {
		this.bm_title = bm_title;
	}
	public int getBm_hit() {
		return bm_hit;
	}
	public void setBm_hit(int bm_hit) {
		this.bm_hit = bm_hit;
	}
	public String getBm_date() {
		return bm_date;
	}
	public void setBm_date(String bm_date) {
		this.bm_date = bm_date;
	}
	public int getBm_like() {
		return bm_like;
	}
	public void setBm_like(int bm_like) {
		this.bm_like = bm_like;
	}
	public String getBm_content() {
		return bm_content;
	}
	public void setBm_content(String bm_content) {
		this.bm_content = bm_content;
	}
	public int getBm_price() {
		return bm_price;
	}
	public void setBm_price(int bm_price) {
		this.bm_price = bm_price;
	}
	public boolean isBm_isSold() {
		return bm_isSold;
	}
	public void setBm_isSold(boolean bm_isSold) {
		this.bm_isSold = bm_isSold;
	}
	public String getMem_email() {
		return mem_email;
	}
	public void setMem_email(String mem_email) {
		this.mem_email = mem_email;
	}
	public int getCategory_no() {
		return category_no;
	}
	public void setCategory_no(int category_no) {
		this.category_no = category_no;
	}
}
