package kr.or.ddit.dam.vo;

public class PaymentVO {
	private Long payment_no;
	private int payment_amt;
	private int use_mileage;
	private String cust_id;
	private String tid;
	
	public String getTid() {
		return tid;
	}
	public void setTid(String tid) {
		this.tid = tid;
	}
	public Long getPayment_no() {
		return payment_no;
	}
	public void setPayment_no(Long payment_no) {
		this.payment_no = payment_no;
	}
	public int getPayment_amt() {
		return payment_amt;
	}
	public void setPayment_amt(int payment_amt) {
		this.payment_amt = payment_amt;
	}
	public int getUse_mileage() {
		return use_mileage;
	}
	public void setUse_mileage(int use_mileage) {
		this.use_mileage = use_mileage;
	}
	public String getCust_id() {
		return cust_id;
	}
	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}

}
