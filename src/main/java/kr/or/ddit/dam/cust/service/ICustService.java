package kr.or.ddit.dam.cust.service;

import java.time.LocalDate;
import java.util.List;

import kr.or.ddit.dam.vo.CustVO;


public interface ICustService {
	
	//모든 리스트 가지고올때
		public List<CustVO> getAllCust();
		
		//고객id
		public CustVO getCustId(String Id);

		//고객회원가입
		public int insertCust(CustVO cvo) throws Exception;

		//고객로그인
		public CustVO loginCust(CustVO cvo);

		//고객 메일 찾기
		public String mailFind(String name, String tel);
		
		// 회원수정
		public int updateCust(CustVO cvo);
		
		/**
		 * 고객이 존재하는지 확인하는 메소드
		 * @param cust_id 고객 아이디
		 * @return count 값
		 */
		public int checkCustIdExists(String cust_id);

		/**
		 * 고객정보 가져옴
		 * @param cust_id 고객아이디
		 * @return
		 */
		public CustVO getCustById(String cust_id);
		
		// 순수 구매액 조회
	    List<CustVO> getMemberGrades(LocalDate startDate, LocalDate endDate);

	    // 회원 등급 업데이트 
	    boolean updateMemberGrade(String cust_id, String mem_grade);
}
