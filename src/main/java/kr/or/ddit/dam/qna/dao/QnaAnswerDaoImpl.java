package kr.or.ddit.dam.qna.dao;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.QnaAnswerVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class QnaAnswerDaoImpl implements IQnaAnswerDao{

	//싱글톤
	private static IQnaAnswerDao dao;
	
	public static IQnaAnswerDao getDao() {
		if(dao == null) dao = new QnaAnswerDaoImpl();
		return dao;
	}
	
	private QnaAnswerDaoImpl() {}
	
	
	@Override
	public int insertAnswer(QnaAnswerVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; //1
		
		try {
			res = session.insert("qna.insertAnswer", vo);
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
	public int updateAnswer(QnaAnswerVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; //1
		
		try {
			res = session.update("qna.updateAnswer", vo);
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
	public int deleteAnswer(int num) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; //1
		
		try {
			res = session.delete("qna.deleteAnswer", num);
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
	public QnaAnswerVO selectAnswerByQid(int qnaQid) {
		SqlSession session = MybatisUtil.getInstance();
		
		QnaAnswerVO qvo = null;
		
		try {
			qvo = session.selectOne("qna.selectAnswerByQid", qnaQid);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		
		return qvo;
	}

	@Override
	public QnaAnswerVO getAnswerByQid(int qnaQid) {
		SqlSession session = MybatisUtil.getInstance();
		
		QnaAnswerVO qvo = null;
		
		try {
			qvo = session.selectOne("qna.getAnswerByQid", qnaQid);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		
		return qvo;
	}

}
