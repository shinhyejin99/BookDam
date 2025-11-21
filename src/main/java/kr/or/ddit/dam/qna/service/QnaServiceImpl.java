package kr.or.ddit.dam.qna.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.qna.dao.AtchFileDaoImpl;
import kr.or.ddit.dam.qna.dao.IAtchFileDao;
import kr.or.ddit.dam.qna.dao.IQnaDao;
import kr.or.ddit.dam.qna.dao.QnaDaoImpl;
import kr.or.ddit.dam.vo.AtchFileVO;
import kr.or.ddit.dam.vo.QnaStatusVO;
import kr.or.ddit.dam.vo.QnaVO;

public class QnaServiceImpl implements IQnaService{

	//싱글톤패턴
	private static IQnaService service;
	
	public static IQnaService getService() {
		if(service == null) service = new QnaServiceImpl();
		return service;
	}
	
	//dao객체
	private IQnaDao dao;
	private IAtchFileDao atchFileDao;
	
	private QnaServiceImpl() {
		dao = QnaDaoImpl.getDao();
		atchFileDao = AtchFileDaoImpl.getInstance();
	}
	
	@Override
	public int insertQna(QnaVO vo) {
		
		//최초 저장시 상태값 강제로 세팅
		if(vo.getQnaStatus() == null || vo.getQnaStatus().isEmpty()) {
			vo.setQnaStatus("답변대기"); //최초상태를 "답변대기"로 지정
		}
		return dao.insertQna(vo);
	}

	@Override
	public int updateQna(QnaVO vo) {
		// TODO Auto-generated method stub
		return dao.updateQna(vo);
	}

	@Override
	public int deleteQna(int num) {
		// TODO Auto-generated method stub
		return dao.deleteQna(num);
	}


	@Override
	public List<QnaVO> getAllQna() {
		// TODO Auto-generated method stub
		return dao.getAllQna();
	}

	@Override
	public QnaVO getQnaByQid(int qnaQid) {
	    
        QnaVO qna = dao.selectQnaByQid(qnaQid);
        if(qna != null) {
            AtchFileVO atchFile = atchFileDao.selectAtchFileByQnaQid(qnaQid);
            qna.setAtchFileVO(atchFile);
        }
	    return qna;
		//return dao.getQnaByQid(qnaQid);
	}

	@Override
	public int updateQnaStatus(int qnaQid, String qnaStatus) {
		// TODO Auto-generated method stub
		return dao.updateQnastatus(qnaQid, qnaStatus);
	}

	@Override
	public List<QnaVO> getMyQnaList(String custId) {
		// TODO Auto-generated method stub
		return dao.getMyQnaList(custId);
	}

	@Override
	public List<QnaVO> getAdminQnaList(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		return dao.getAdminQnaList(paramMap);
	}

	@Override
	public QnaVO getQnaWithEmailByQid(int qnaQid) {
	    QnaVO qna = dao.getQnaByQid(qnaQid); // 이메일 포함 쿼리
	    if(qna != null) {
	        AtchFileVO atchFile = atchFileDao.selectAtchFileByQnaQid(qnaQid);
	        qna.setAtchFileVO(atchFile);
	    }
	    return qna;
	}

	// 고객의 문의 상황(답변 대기, 완료) 카운트를 가져오는 메소드 - 마이페이지에서 활용
	@Override
	public QnaStatusVO getQnaStatusCnt(String cust_id) {
		return dao.getQnaStatusCnt(cust_id);
	}

}
