package kr.or.ddit.dam.admin.dao;


import java.util.Map;

import kr.or.ddit.dam.vo.AdminVO;

public interface IAdminDao {

	

	// 로그인
	public AdminVO loginAdmin(Map<String, String> map);
}
