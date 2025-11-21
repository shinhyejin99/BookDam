package kr.or.ddit.dam.mem.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.vo.MileageVO;

public interface IMemService {

	// 메소드 선언
	public List<MemVO> getAllMember();

	// 로그인
	public MemVO loginMember(MemVO vo);

	// 이메일 체크
	public String mailcheck(String mail);

	// 닉네임 체크
	public String nicknamecheck(String nickname);

	// 가입하기
	public int insertMember(MemVO vo);

	// 비밀번호 찾기
	public String PassFind(String mail, String bir);

	// 비밀번호 이메일 인증
	public boolean isEmailExists(String mem_mail);

	// 회원 수정전 비밀번호 확인
	public boolean checkPassword(String mem_pass, String mem_mail);

	// 회원 수정
	public int updateMember(MemVO mvo);

	// 회원탈퇴
	public int resignMember(String mem_mail);

	public MemVO getMember(String mem_mail);

	/**
	 * 환불 후 마일리지 업데이트하는 메소드
	 *
	 * @param memMap 멤버이메일, 사용했던마일리지, 적립받았던마일리지를 담은 vo
	 * @return 성공하면 1, 실패하면 0
	 */
	public int updateMileage(SqlSession sqlSession, Map<String, Object> memMap);

	/**
	 * 환불 후 Mileage 테이블에 마일리지 내역 insert
	 *
	 * @param sqlSession 환불 트랜젝션을 위한 sqlSession
	 * @param memMap     멤버이메일, 사용했던마일리지, 적립받았던마일리지를 담은 vo
	 * @return 성공하면 1, 실패하면 0
	 */

	public int insertUsedMileageInfo(SqlSession sqlSession, Map<String, Object> memMap);

	/**
	 * 환불 후 Mileage 테이블에 마일리지 내역 insert
	 *
	 * @param sqlSession 환불 트랜젝션을 위한 sqlSession
	 * @param memMap     멤버이메일, 사용했던마일리지, 적립받았던마일리지를 담은 vo
	 * @return 성공하면 1, 실패하면 0
	 */
	public int insertEarnedMileageInfo(SqlSession sqlSession, Map<String, Object> memMap);

	/**
	 * 회원별로 마일리지 내역을 얻어오는 메소드 (마이페이지)
	 *
	 * @param mem_mail 회원 이메일
	 * @return 마일리지 내역 List
	 */
	public List<MileageVO> getMileageList(String mem_mail);

	/**
	 * 회원의 한 달 구매 금액을 조회하는 메소드
	 *
	 * @param mem_mail 회원 이메일
	 * @return 한 달 환불 금액
	 */
	public int getMemMonthlyBuy(String mem_mail);

	/**
	 * 구매금액에 따라 Member 테이블의 회원 등급 update
	 *
	 * @param memMap 멤버이메일과 구매금액을 저장한 map
	 * @return 성공하면 1, 실패하면 0
	 */
	public int updateMemGrade(Map<String, Object> memMap);

	// 회원정보 검색
	public List<MemVO> searchMember(String searchType, String searchValue, String birthStart, String birthEnd,
			String joinStart, String joinEnd, String addr, String grade);

	String processPassFind(String mail, String bir);

	String getMemberForPassFind(String mail, String bir);

	int updateTempPassword(Map<String, String> param);

	/** SHA-256 암호화 */
	String encryptSHA256(String str);
}
