package kr.or.ddit.dam.admin.service;

import kr.or.ddit.dam.vo.AdminVO;

public interface IAdminService {

	
	//관리자 로그인
	public AdminVO loginAdmin(String admin_id, String admin_pass);
}
