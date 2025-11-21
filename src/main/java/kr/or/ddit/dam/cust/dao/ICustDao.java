package kr.or.ddit.dam.cust.dao;

import java.util.List;
import java.util.Map;



import kr.or.ddit.dam.vo.CustVO;


public interface ICustDao {

	public List<CustVO> getAllCust();
	
	public CustVO getCustId(String Id);

	int insertCust(CustVO vo);

	public int checkCustIdExists(String custId);

	public CustVO loginCust(CustVO cvo);
	
	String mailFind (String name, String tel);
	
	public int updateCust(CustVO cvo);

	public CustVO getCustById(String cust_id);
	
	/**
	 * 회원 등급을 업데이트
	 * @param params cust_id와 mem_grade를 포함한 Map
	 * @return 업데이트된 레코드 수
	 */
	
	//멤버등급
	public int updateMemberGrade(Map<String, Object> params);
	
	//순수익
	public List<CustVO> getMemberGradesByDateRange(Map<String, Object> paramMap);

	

	
}
