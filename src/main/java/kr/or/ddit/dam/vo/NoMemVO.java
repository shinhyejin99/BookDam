package kr.or.ddit.dam.vo;

public class NoMemVO {
	
	
	private String nmem_mail;
	private String nmem_pass;
	
	
	
	public String getNmem_mail() {
		return nmem_mail;
	}
	public void setNmem_mail(String nmem_mail) {
		this.nmem_mail = nmem_mail;
	}
	public String getNmem_pass() {
		return nmem_pass;
	}
	public void setNmem_pass(String nmem_pass) {
		this.nmem_pass = nmem_pass;
	
		
	
	}
	public NoMemVO(String nmem_mail, String nmem_pass) {
		super();
		this.nmem_mail = nmem_mail;
		this.nmem_pass = nmem_pass;
	}
	
	public NoMemVO() {
		
	}

	
	
}
