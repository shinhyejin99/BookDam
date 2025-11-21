package kr.or.ddit.dam.vo;

public class OrdersVO {
	private long order_no;
	private String order_status;
	private String cust_id;
	private int total_amt;
	private int cart_no;
	private String nmem_check;
	
	public long getOrder_no() {
		return order_no;
	}
	public void setOrder_no(long order_no) {
		this.order_no = order_no;
	}
	public String getOrder_status() {
		return order_status;
	}
	public void setOrder_status(String order_status) {
		this.order_status = order_status;
	}
	public String getCust_id() {
		return cust_id;
	}
	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}
	public int getTotal_amt() {
		return total_amt;
	}
	public void setTotal_amt(int total_amt) {
		this.total_amt = total_amt;
	}
	public int getCart_no() {
		return cart_no;
	}
	public void setCart_no(int cart_no) {
		this.cart_no = cart_no;
	}
	public String getNmem_check() {
		return nmem_check;
	}
	public void setNmem_check(String nmem_check) {
		this.nmem_check = nmem_check;
	}
}
