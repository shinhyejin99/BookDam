package kr.or.ddit.dam.admin.service;

import java.util.HashMap;
import java.util.Map;

import kr.or.ddit.dam.admin.dao.AdminDaoImpl;
import kr.or.ddit.dam.admin.dao.IAdminDao;
import kr.or.ddit.dam.vo.AdminVO;

public class AdminServiceImpl  implements IAdminService{

	private static IAdminService service;
	private IAdminDao dao;
	
	  private AdminServiceImpl() {
	        dao = AdminDaoImpl.getDao();
	    }
	  
	public static IAdminService getService() {
		if(service == null)service = new AdminServiceImpl();
		
		return service;
	}

	@Override
	public AdminVO loginAdmin(String admin_id, String admin_pass) {
	    Map<String, String> map = new HashMap<>();
	    map.put("admin_id", admin_id);      
	    map.put("admin_pass", admin_pass); 
	    return dao.loginAdmin(map);        
	}

}
