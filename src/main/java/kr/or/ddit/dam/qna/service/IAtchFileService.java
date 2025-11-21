package kr.or.ddit.dam.qna.service;

import java.util.Collection;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import kr.or.ddit.dam.vo.AtchFileDetailVO;
import kr.or.ddit.dam.vo.AtchFileVO;

/*
 * 첨부파일 저장을 위한 공통 서비스용 인터페이스
 */
public interface IAtchFileService {
	
	/**
	 * 첨부파일 목록을 저장하기 위한 메서드
	 * @param parts
	 * @return 첨부파일 저장 성공시 atchFileId를 담은 AtchFileVO를 반환함
	 * 		   첨부파일 존재하지 않으면 null 반환함
	 */
	public AtchFileVO saveAtchFileList(Collection<Part> parts, int qnaQid);
	
	/**
	 * 첨부파일 조회(세부 첨부파일 목록)
	 * @param atchFileVO 세부 첨부파일 목록을 조회하기 위한 atchFileId를 담은 객체
	 * @return 세부 첨부파일 목록을 담은 AtchFileVO 객체
	 */
	public AtchFileVO getAtchFile(AtchFileVO atchFileVO);
	
	/**
	 * 첨부파일 상세정보 조회(첨부파일 다운로드 처리시 사용)
	 * @param atchFileDetailVO atchFileId 및 fileSn을 담은 객체
	 * @return 첨부파일 상세정보를 담은 AtchFileDetailVO 객체
	 */
	public AtchFileDetailVO getAtchFileDetail(AtchFileDetailVO atchFileDetailVO);
	
	
	/**
	 * 첨부파일에 QNA 게시글 번호(qnaQid)를 연동하는 메서드
	 * @param qnaQid 게시글 번호
	 * @param atchFileId 첨부파일 ID
	 * @return 업데이트 성공 건수 (1이면 성공)
	 */
	public int updateQnaQidForAtchFile(int qnaQid, Long atchFileId);
	
	
	//Qna 첨부파일 조회 메서드
	public AtchFileVO getAtchFileByQnaQid(int qnaQid);

	AtchFileVO saveAtchFileList(Collection<Part> parts, int qnaQid, HttpServletRequest request);
	
}
