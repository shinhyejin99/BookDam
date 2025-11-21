package kr.or.ddit.dam.qna.dao;

import kr.or.ddit.dam.vo.QnaAnswerVO;

public interface IQnaAnswerDao {

	//문의사항 답변작성
	public int insertAnswer(QnaAnswerVO vo);
	
	//문의사항 수정
	public int updateAnswer(QnaAnswerVO vo);
	
	//문의사항 삭제
	public int deleteAnswer(int num);
	
	//문의글 id로 답변조회
	QnaAnswerVO selectAnswerByQid(int qnaQid);
	
	//특정 QID로 답변정보를 가져오기
	QnaAnswerVO getAnswerByQid(int qnaQid);
	
}
