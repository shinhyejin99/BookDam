package kr.or.ddit.dam.vo;

public class CartDetailVO {
	String cust_id;
	long cart_no;
	long book_no;
	int cart_qty;
	
	public String getCust_id() {
		return cust_id;
	}
	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}
	public long getCart_no() {
		return cart_no;
	}
	public void setCart_no(long cart_no) {
		this.cart_no = cart_no;
	}
	public long getBook_no() {
		return book_no;
	}
	public void setBook_no(long book_no) {
		this.book_no = book_no;
	}
	public int getCart_qty() {
		return cart_qty;
	}
	public void setCart_qty(int cart_qty) {
		this.cart_qty = cart_qty;
	}
	
}
