package kr.or.ddit.dam.qna.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.QnaStatusVO;
import kr.or.ddit.dam.vo.QnaVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class QnaDaoImpl implements IQnaDao{

	//싱글톤
	private static IQnaDao dao;
	
	public static IQnaDao getDao() {
		if(dao == null) dao = new QnaDaoImpl();
		return dao;
	}
	
	
	
	private QnaDaoImpl() {}
	
	@Override
	public int insertQna(QnaVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; // 1
		
		try {
			res = session.insert("qna.insertQna", vo); //2
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res; //3
	}

	@Override
	public int updateQna(QnaVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
		
		try {
			res = session.update("qna.updateQna", vo);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res;
	}

	@Override
	public int deleteQna(int num) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
		
		try {
			res = session.delete("qna.deleteQna", num);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res;
	}

	@Override
	public List<QnaVO> getAllQna() {
		SqlSession session = MybatisUtil.getInstance();
		List<QnaVO> list = null; //1
		
		try {
			list = session.selectList("qna.getAllQna"); //2
			
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
	public QnaVO getQnaByQid(int qnaQid) {
		SqlSession session = MybatisUtil.getInstance();
		QnaVO qvo = null;
		
		try {
			qvo = session.selectOne("qna.getQnaByQid", qnaQid); //2
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		return qvo; //3
	}



	@Override
	public QnaVO selectQnaByQid(int qnaQid) {
	    try (SqlSession session = MybatisUtil.getInstance()) {
	    	QnaVO cvo = session.selectOne("qna.selectQnaByQid", qnaQid);
	        System.out.println(cvo.getQnaQid());
	    	return cvo;
	    }
	}



	@Override
	public int updateQnastatus(int qnaQid, String qnaStatus) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
		
		try {
	        // 파라미터 두 개를 맵에 담아서 전달
	        Map<String, Object> paramMap = new HashMap<>();
	        paramMap.put("qnaQid", qnaQid);
	        paramMap.put("qnaStatus", qnaStatus);
	        
	        //매퍼에서 updateQnaStatus라는 id로 update쿼리 실행
	        res = session.update("qna.updateQnaStatus", paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res;
	}



	@Override
	public List<QnaVO> getMyQnaList(String custId) {
		SqlSession session = MybatisUtil.getInstance();
		List<QnaVO> list = null; //1
		
		try {
			list = session.selectList("qna.getMyQnaList", custId); //2
			
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
	public List<QnaVO> getAdminQnaList(Map<String, Object> paramMap) {
		SqlSession session = MybatisUtil.getInstance();
		List<QnaVO> list = null; //1
		
		try {
			list = session.selectList("qna.getAdminQnaList", paramMap); //2
			
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



	// 고객의 문의 상황(답변 대기, 완료) 카운트를 가져오는 메소드 - 마이페이지에서 활용
	@Override
	public QnaStatusVO getQnaStatusCnt(String cust_id) {
		QnaStatusVO qvo = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			qvo = session.selectOne("qna.getQnaStatusCnt", cust_id);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return qvo;
	}

}
