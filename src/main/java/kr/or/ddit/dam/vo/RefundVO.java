package kr.or.ddit.dam.vo;

public class RefundVO {
	private Long order_no;
	private String rfd_date;
	private int rfd_amt;
	private int rfd_use_mileage;
	private int rfd_earned_mileage;
	private String rfd_reason;
	
	public Long getOrder_no() {
		return order_no;
	}
	public void setOrder_no(Long order_no) {
		this.order_no = order_no;
	}
	public String getRfd_date() {
		return rfd_date;
	}
	public void setRfd_date(String rfd_date) {
		this.rfd_date = rfd_date;
	}
	public int getRfd_amt() {
		return rfd_amt;
	}
	public void setRfd_amt(int rfd_amt) {
		this.rfd_amt = rfd_amt;
	}
	public int getRfd_use_mileage() {
		return rfd_use_mileage;
	}
	public void setRfd_use_mileage(int rfd_use_mileage) {
		this.rfd_use_mileage = rfd_use_mileage;
	}
	public int getRfd_earned_mileage() {
		return rfd_earned_mileage;
	}
	public void setRfd_earned_mileage(int rfd_earned_mileage) {
		this.rfd_earned_mileage = rfd_earned_mileage;
	}
	public String getRfd_reason() {
		return rfd_reason;
	}
	public void setRfd_reason(String rfd_reason) {
		this.rfd_reason = rfd_reason;
	}
	
}
