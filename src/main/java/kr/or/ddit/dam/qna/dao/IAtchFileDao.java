package kr.or.ddit.dam.qna.dao;

import kr.or.ddit.dam.vo.AtchFileDetailVO;
import kr.or.ddit.dam.vo.AtchFileVO;

public interface IAtchFileDao {

	/**
	 * 첨부파일저장
	 * @param atchFileVO
	 * @return
	 */
	public int insertAtchFile(AtchFileVO atchFileVO);
	

	/**
	 * 첨부파일 세부정보 저장
	 * @param atchFileDetailVO 첨부파일 세부정보를 담은 VO객체
	 * @return
	 */
	public int insertAtchFileDetail(AtchFileDetailVO atchFileDetailVO);

	/**
	 * 첨부파일 조회하기(첨부파일 목록)
	 * @param atchFileVO
	 * @return 세부 첨부파일 목록을 담은 AtchFileVO객체 
	 */
	public AtchFileVO getAtchFile(AtchFileVO atchFileVO);
	
	/**
	 * 첨부파일 상세정보 조회 메서드
	 * @param atchFileDetailVO
	 * @return 세부 첨부파일 내용을 담은 AtchFileDetailVO객체
	 */
	public AtchFileDetailVO getAtchFileDetail(AtchFileDetailVO atchFileDetailVO);


	/**
	 * 첨부파일에 QNA 게시글 번호(qnaQid)를 연동하는 메서드
	 * @param qnaQid 게시글 번호
	 * @param atchFileId 첨부파일 ID
	 * @return 업데이트 성공 건수 (1이면 성공)
	 */
	public int updateQnaQidForAtchFile(int qnaQid, Long atchFileId);
	
	/**
	 * qnaQid로 첨부파일 목록 조회
	 * @param qnaQid 문의글 ID
	 * @return 첨부파일 정보를 담은 AtchFileVO 객체
	 */
	public AtchFileVO selectAtchFileByQnaQid(int qnaQid);
}
