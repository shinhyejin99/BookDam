package kr.or.ddit.dam.vo;

import java.util.List;

public class DelCartVO {
	private String cust_id;
	private List<CartItemVO> book_no;
	
	public String getCust_id() {
		return cust_id;
	}
	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}
	public List<CartItemVO> getBook_no() {
		return book_no;
	}
	public void setBook_no(List<CartItemVO> book_no) {
		this.book_no = book_no;
	}
	
	@Override
	public String toString() {
		return "DelCartVO [cust_id=" + cust_id + ", book_no=" + book_no + "]";
	}
	
	
	
	
}
