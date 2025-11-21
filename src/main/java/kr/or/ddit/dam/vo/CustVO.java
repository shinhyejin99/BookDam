package kr.or.ddit.dam.vo;

public class CustVO {
	
	private String cust_id;
	private String cust_name;
	private String cust_zip;
	private String cust_addr1;
	private String cust_addr2;
	private String cust_tel;
	// 가영 추가
	private Long order_no;
	
	//회원등급
	private String mem_grade;
	
	//순수총액
	private double total_amt;
	
	
	public CustVO(String mem_grade, double total_amt) {
		super();
		this.mem_grade = mem_grade;
		this.total_amt = total_amt;
	}

	public String getMem_grade() {
		return mem_grade;
	}

	public void setMem_grade(String mem_grade) {
		this.mem_grade = mem_grade;
	}

	public double getTotal_amt() {
		return total_amt;
	}

	public void setTotal_amt(double total_amt) {
		this.total_amt = total_amt;
	}

	public CustVO() {}
	
	public CustVO(String cust_id, String cust_name, String cust_zip, String cust_addr1, String cust_addr2,
			String cust_tel) {
		super();
		this.cust_id = cust_id;
		this.cust_name = cust_name;
		this.cust_zip = cust_zip;
		this.cust_addr1 = cust_addr1;
		this.cust_addr2 = cust_addr2;
		this.cust_tel = cust_tel;
	}
	
	// 가영 추가
	public CustVO(String cust_id, String cust_name, String cust_zip, String cust_addr1, String cust_addr2,
			String cust_tel, Long order_no) {
		super();
		this.cust_id = cust_id;
		this.cust_name = cust_name;
		this.cust_zip = cust_zip;
		this.cust_addr1 = cust_addr1;
		this.cust_addr2 = cust_addr2;
		this.cust_tel = cust_tel;
		this.order_no = order_no;
	}
	
	public String getCust_id() {
		return cust_id;
	}
	public void setCust_id(String cust_id) {
		this.cust_id = cust_id;
	}
	public String getCust_name() {
		return cust_name;
	}
	public void setCust_name(String cust_name) {
		this.cust_name = cust_name;
	}
	public String getCust_zip() {
		return cust_zip;
	}
	public void setCust_zip(String cust_zip) {
		this.cust_zip = cust_zip;
	}
	public String getCust_addr1() {
		return cust_addr1;
	}
	public void setCust_addr1(String cust_addr1) {
		this.cust_addr1 = cust_addr1;
	}
	public String getCust_addr2() {
		return cust_addr2;
	}
	public void setCust_addr2(String cust_addr2) {
		this.cust_addr2 = cust_addr2;
	}
	public String getCust_tel() {
		return cust_tel;
	}
	public void setCust_tel(String cust_tel) {
		this.cust_tel = cust_tel;
	}

	// 가영 추가
	public Long getOrder_no() {
		return order_no;
	}

	public void setOrder_no(Long order_no) {
		this.order_no = order_no;
	}
}
