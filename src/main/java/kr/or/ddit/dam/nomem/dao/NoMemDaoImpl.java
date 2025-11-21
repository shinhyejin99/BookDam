package kr.or.ddit.dam.nomem.dao;

import java.util.List;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.NoMemVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class NoMemDaoImpl implements INoMemDao {

	// 싱글톤 (필드)
	private static INoMemDao nodao;

	// 싱글톤 (메소드)
	public static INoMemDao getNoDao() {

		
		if(nodao == null)nodao = new NoMemDaoImpl();
		
		return nodao;
		
	}

	// 싱글톤 (생성자)
	private NoMemDaoImpl() {
		
	}
	
	
	@Override
	public List<NoMemVO> getAllNoMember() {
		
		SqlSession session = MybatisUtil.getInstance();
		
		List<NoMemVO> list = null;
		
		try{
			
			list = session.selectList("nomember.getAllMember");
		
		}catch(Exception e) {
			e.printStackTrace();
		
		}finally {
			
			 if(session != null) {
				 
				 session.commit();
				 session.close();
			 }
			
		}
		return list;
	}

	@Override
	public List<NoMemVO> NoMemberOrder(NoMemVO nvo) {

	    System.out.println("메일: " + nvo.getNmem_mail());
	    System.out.println("비번: " + nvo.getNmem_pass());

	    SqlSession session = MybatisUtil.getInstance();

	    List<NoMemVO> result = null;

	    try {
	        result = session.selectList("nomember.NoMemberOrder", nvo);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.commit();
	            session.close();
	        }
	    }

	    return result;
	}

	// 가영 추가
	@Override
	public int insertNoMember(SqlSession sqlSession, NoMemVO vo) {
		int cnt = 0;
		
		try {
			cnt = sqlSession.insert("nomember.insertNoMember", vo);
			
		} catch(PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			// session.commit(); 결제 후처리 후 서블릿에서 commit, close
			// session.close();
		}
		
		return cnt;
	}
}
