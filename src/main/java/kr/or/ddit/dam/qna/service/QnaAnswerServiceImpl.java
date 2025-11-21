package kr.or.ddit.dam.qna.service;

import kr.or.ddit.dam.qna.dao.IQnaAnswerDao;
import kr.or.ddit.dam.qna.dao.QnaAnswerDaoImpl;
import kr.or.ddit.dam.vo.QnaAnswerVO;

public class QnaAnswerServiceImpl implements IQnaAnswerService{

	private IQnaAnswerDao answerDao = QnaAnswerDaoImpl.getDao();
	//싱글톤패턴
	private static IQnaAnswerService service;
	
	public static IQnaAnswerService getService() {
		if(service == null) service = new QnaAnswerServiceImpl();
		return service;
	}
	
	//dao객체
	private IQnaAnswerDao dao;
	
	private QnaAnswerServiceImpl() {
		dao = QnaAnswerDaoImpl.getDao();
	}
	
	@Override
	public int insertAnswer(QnaAnswerVO vo) {
		// TODO Auto-generated method stub
		return dao.insertAnswer(vo);
	}

	@Override
	public int updateAnswer(QnaAnswerVO vo) {
		// TODO Auto-generated method stub
		return dao.updateAnswer(vo);
	}

	@Override
	public int deleteAnswer(int num) {
		// TODO Auto-generated method stub
		return dao.deleteAnswer(num);
	}

	@Override
	public QnaAnswerVO selectAnswerByQid(int qnaQid) {
		// TODO Auto-generated method stub
		return dao.selectAnswerByQid(qnaQid);
	}

	@Override
	public QnaAnswerVO getAnswerByQid(int qnaQid) {
		// TODO Auto-generated method stub
		return answerDao.selectAnswerByQid(qnaQid);
	}

}
