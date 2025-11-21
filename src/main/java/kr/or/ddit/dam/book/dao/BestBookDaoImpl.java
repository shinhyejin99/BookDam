package kr.or.ddit.dam.book.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.BestBookVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class BestBookDaoImpl implements IBestBookDao{

	//싱글톤
	private static IBestBookDao dao;
	
	public static IBestBookDao getDao() {
		if(dao == null) dao = new BestBookDaoImpl();
		return dao;
	}
	
	private BestBookDaoImpl() {}

	@Override
	public List<BestBookVO> selectBestBook() {
		SqlSession session = MybatisUtil.getInstance();
		List<BestBookVO> list = null; //1
		
		try {
			list = session.selectList("bestBook.selectBestBook"); //2
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		return list; //3
	}

	@Override
	public List<BestBookVO> selectAge(String ageRange) {
		SqlSession session = MybatisUtil.getInstance();
		List<BestBookVO> list = null; //1
		
		try {
			list = session.selectList("bestBook.selectAge", ageRange); //2
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		return list; //3
	}

	@Override
	public String selectCategory() {
	    SqlSession session = MybatisUtil.getInstance();
	    String category = null;

	    try {
	        category = session.selectOne("bestBook.selectCategory");
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.commit();
	            session.close();
	        }
	    }

	    return category;
	}

	@Override
	public List<BestBookVO> selectTopCategory(String category) {
		SqlSession session = MybatisUtil.getInstance();
		List<BestBookVO> list = null; //1
		
		try {
			list = session.selectList("bestBook.selectTopCategory", category); //2
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		return list; //3
	}
	
}
