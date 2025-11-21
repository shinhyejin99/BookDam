package kr.or.ddit.dam.admin.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.AdminVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class AdminDaoImpl implements IAdminDao{

	
	private static IAdminDao dao;
	
	public static IAdminDao getDao() {
		
		if(dao == null) dao = new AdminDaoImpl();
		
		return dao;
	}

	@Override
	public AdminVO loginAdmin(Map<String, String> paramMap) {
		
		SqlSession session = MybatisUtil.getInstance();
		
		AdminVO avo = null ;
		
		try{
			
			avo = session.selectOne("admin.loginAdmin", paramMap);
		
		}catch(Exception e) {
			e.printStackTrace();
		
		}finally {
			
			 if(session != null) {
			
				 session.close();
			 }
			
		}
		return avo;
	}


}