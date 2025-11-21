package kr.or.ddit.dam.vo;

public class AdminVO {

	
	private String admin_id;
	private String admin_pass;
	
	 public AdminVO() {}
	
	
	public String getAdmin_id() {
		return admin_id;
	}
	public void setAdmin_id(String admin_id) {
		this.admin_id = admin_id;
	}
	public String getAdmin_pass() {
		return admin_pass;
	}
	public void setAdmin_pass(String admin_pass) {
		this.admin_pass = admin_pass;
	}
	
	public AdminVO(String admin_id, String admin_pass) {
		super();
		this.admin_id = admin_id;
		this.admin_pass = admin_pass;
	}
	
	
}
