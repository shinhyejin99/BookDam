package kr.or.ddit.dam.qna.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.QnaStatusVO;
import kr.or.ddit.dam.vo.QnaVO;

public interface IQnaService {

	//문의사항 쓰기
	public int insertQna(QnaVO vo);
	
	//문의사항 수정
	public int updateQna(QnaVO vo);
	
	//문의사항 삭제
	public int deleteQna(int num);
	
	//전체 문의사항 조회
	public List<QnaVO> getAllQna();

    //로그인한 사용자의 문의글만 조회
    public List<QnaVO> getMyQnaList(String custId);
	
    //문의사항 검색
    public List<QnaVO> getAdminQnaList(Map<String, Object> paramMap);
    
	//문의사항 원글 조회
	public QnaVO getQnaByQid(int qnaQid);
	
	//문의사항 상태변경
	public int updateQnaStatus(int qnaQid, String qnaStatus);

	public QnaVO getQnaWithEmailByQid(int qnaQid);
	
	/**
	 * 고객의 문의 상황(답변 대기, 완료) 카운트를 가져오는 메소드 - 마이페이지에서 활용
	 * @param cust_id 고객 아이디
	 * @return 답변대기, 답변완료 카운트를 저장한 vo
	 */
	public QnaStatusVO getQnaStatusCnt(String cust_id);
}
