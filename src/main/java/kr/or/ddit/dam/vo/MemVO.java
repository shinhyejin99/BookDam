package kr.or.ddit.dam.vo;

import java.sql.Date;

public class MemVO {
	
	//기본mem
	private String mem_mail;
	private String mem_pass;
	private int mem_bir;
	private String mem_nickname;
	private int mem_mileage;
	private String mem_grade;
	private String mem_gender;
	private Date mem_join;
	private String mem_resign;
	
	//고객정보 join할 cust정보
	private String cust_name;
	private String cust_zip;
	private String cust_addr1;
	private String cust_addr2;
	private String cust_tel;
	

	
	

	public String getMem_mail() {
		return mem_mail;
	}
	public void setMem_mail(String mem_mail) {
		this.mem_mail = mem_mail;
	}
	public String getMem_pass() {
		return mem_pass;
	}
	public void setMem_pass(String mem_pass) {
		this.mem_pass = mem_pass;
	}
	public int getMem_bir() {
		return mem_bir;
	}
	public void setMem_bir(int mem_bir) {
		this.mem_bir = mem_bir;
	}
	public String getMem_nickname() {
		return mem_nickname;
	}
	public void setMem_nickname(String mem_nickname) {
		this.mem_nickname = mem_nickname;
	}
	public int getMem_mileage() {
		return mem_mileage;
	}
	public void setMem_mileage(int mem_mileage) {
		this.mem_mileage = mem_mileage;
	}
	public String getMem_grade() {
		return mem_grade;
	}
	public void setMem_grade(String mem_grade) {
		this.mem_grade = mem_grade;
	}
	public String getMem_gender() {
		return mem_gender;
	}
	public void setMem_gender(String mem_gender) {
		this.mem_gender = mem_gender;
	}
	public Date getMem_join() {
		return mem_join;
	}
	public void setMem_join(Date mem_join) {
		this.mem_join = mem_join;
	}
	public String getMem_resign() {
		return mem_resign;
	}
	public void setMem_resign(String mem_resign) {
		this.mem_resign = mem_resign;
	}
	
	
	public MemVO(String mem_mail, String mem_pass, int mem_bir, String mem_nickname, int mem_mileage,
			String mem_grade, String mem_gender, Date mem_join, String mem_resign) {
		super();
		this.mem_mail = mem_mail;
		this.mem_pass = mem_pass;
		this.mem_bir = mem_bir;
		this.mem_nickname = mem_nickname;
		this.mem_mileage = mem_mileage;
		this.mem_grade = mem_grade;
		this.mem_gender = mem_gender;
		this.mem_join = mem_join;
		this.mem_resign = mem_resign;
	}
	
	 public MemVO() {
		
	}
	 
	 //고객 join 
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
	public MemVO(String mem_mail, String mem_pass, int mem_bir, String mem_nickname, int mem_mileage, String mem_grade,
			String mem_gender, Date mem_join, String mem_resign, String cust_name, String cust_zip, String cust_addr1,
			String cust_addr2, String cust_tel) {
		super();
		this.mem_mail = mem_mail;
		this.mem_pass = mem_pass;
		this.mem_bir = mem_bir;
		this.mem_nickname = mem_nickname;
		this.mem_mileage = mem_mileage;
		this.mem_grade = mem_grade;
		this.mem_gender = mem_gender;
		this.mem_join = mem_join;
		this.mem_resign = mem_resign;
		this.cust_name = cust_name;
		this.cust_zip = cust_zip;
		this.cust_addr1 = cust_addr1;
		this.cust_addr2 = cust_addr2;
		this.cust_tel = cust_tel;
	}
	
	
	 
	
}
