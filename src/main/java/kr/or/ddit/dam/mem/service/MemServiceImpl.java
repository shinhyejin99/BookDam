package kr.or.ddit.dam.mem.service;

import java.security.MessageDigest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.mem.dao.IMemDao;
import kr.or.ddit.dam.mem.dao.MemDaoImpl;
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.vo.MileageVO;
import kr.or.ddit.mybatis.config.MybatisUtil;


public class MemServiceImpl implements IMemService{

	private static IMemService service;

	public static IMemService getService() {

		if(service == null) service = new MemServiceImpl();


		return service;
	}

	private IMemDao  dao;

	public MemServiceImpl(){
		dao = MemDaoImpl.getDao();

	}

	@Override
	public List<MemVO> getAllMember() {

		return dao.getAllMember();
	}

	@Override
	public MemVO loginMember(MemVO vo) {

		return dao.loginMember(vo);
	}

	@Override
	public String mailcheck(String mail) {

		return dao.mailcheck(mail);
	}

	public boolean isEmailDuplicated(String mail) {
	    String existingMail = dao.mailcheck(mail);
	    return existingMail != null; // null이 아니면 중복 (true), null이면 중복 아님 (false)
	}

	@Override
	public String nicknamecheck(String nickname) {

		return dao.nicknamecheck(nickname);
	}


	@Override
	public int insertMember(MemVO vo) {

		String existingMail = dao.mailcheck(vo.getMem_mail());

	    if (existingMail != null) {
	        // 이메일이 이미 존재하면 -1 등의 특정 값을 반환하여 중복임을 알림
	        System.out.println("이미 존재하는 이메일입니다: " + vo.getMem_mail());
	        return -1; // 또는 사용자 정의 에러 코드
	    } else {
	        // 중복이 아니면 삽입 진행
	        System.out.println("새로운 이메일입니다. 회원가입을 진행합니다.");
	        return dao.insertMember(vo);
	    }
	}


		@Override
		public String PassFind(String mail, String bir) {

			return dao.PassFind(mail, bir);
		}

		@Override
		public boolean isEmailExists(String mem_mail) {

			 return dao.selectMemberByEmail(mem_mail) != null;
		}
		@Override
		public boolean checkPassword(String mem_pass, String mem_mail) {

			return dao.checkPassword(mem_pass, mem_mail);
		}

		@Override
		public int updateMember(MemVO mvo) {

			return dao.updateMember(mvo);
		}

		@Override
		public int resignMember(String mem_mail) {

			return dao.resignMember(mem_mail);
		}

		@Override
		public MemVO getMember(String mem_mail) {

			return dao.getMember(mem_mail);
		}

		// 환불 후 마일리지 업데이트하는 메소드
		@Override
		public int updateMileage(SqlSession sqlSession, Map<String, Object> memMap) {
			return dao.updateMileage(sqlSession, memMap);
		}

		// 환불 후 Mileage 테이블에 내역 insert
		@Override
		public int insertUsedMileageInfo(SqlSession sqlSession, Map<String, Object> memMap) {
			return dao.insertUsedMileageInfo(sqlSession, memMap);
		}

		// 환불 후 Mileage 테이블에 내역 insert
		@Override
		public int insertEarnedMileageInfo(SqlSession sqlSession, Map<String, Object> memMap) {
			return dao.insertEarnedMileageInfo(sqlSession, memMap);
		}

		// 회원 별로 마일리지 내역을 얻어오는 메소드
		@Override
		public List<MileageVO> getMileageList(String mem_mail) {
			return dao.getMileageList(mem_mail);
		}

		@Override
		public List<MemVO> searchMember(String searchType, String searchValue, String birthStart, String birthEnd,
				String joinStart, String joinEnd, String addr, String grade) {
			// 파라미터 맵 설정
		    Map<String, Object> paramMap = new HashMap<>();
		    paramMap.put("searchType", searchType);
		    paramMap.put("searchValue", searchValue);
		    paramMap.put("birthStart", birthStart);
		    paramMap.put("birthEnd", birthEnd);
		    paramMap.put("joinStart", joinStart);
		    paramMap.put("joinEnd", joinEnd);
		    paramMap.put("addr", addr);
		    paramMap.put("grade", grade);

		    // DAO의 searchMember 메서드를 호출하여 결과 반환
		    return dao.searchMember(paramMap);
		}

		// 회원의 한 달 구매 금액을 조회하는 메소드
		@Override
		public int getMemMonthlyBuy(String mem_mail) {
			return dao.getMemMonthlyBuy(mem_mail);
		}

		// 구매금액에 따라 Member 테이블의 회원 등급 update
		@Override
		public int updateMemGrade(Map<String, Object> memMap) {
			return dao.updateMemGrade(memMap);
		}

		@Override
		public String getMemberForPassFind(String mail, String bir) {
		    return dao.getMemberForPassFind(mail, bir);
		}

		@Override
		public int updateTempPassword(Map<String, String> param) {
		    return dao.updateTempPassword(param);
		}

		/**
		 * 비밀번호 찾기 리팩토링 핵심
		 * - 메일 발송 없음
		 * - 임시 비밀번호 화면 출력
		 * - DB에는 SHA-256 해시 저장
		 */
		@Override
		public String processPassFind(String mail, String bir) {

		    // 1) 회원 존재 여부 확인
		    String exist = dao.getMemberForPassFind(mail, bir);
		    if (exist == null) {
		        return null;
		    }

		    // 2) 임시 비밀번호 생성
		    String tempPass = genTempPassword();

		    // 3) SHA-256 해시 암호화
		    String enc = encryptSHA256(tempPass);

		    // 4) 저장할 파라미터 구성
		    Map<String, String> map = new HashMap<>();
		    map.put("mem_mail", mail);
		    map.put("mem_pass", enc);

		    // 5) DB 업데이트
		    dao.updateTempPassword(map);

		    // 6) 화면에 보여줄 비밀번호 반환 (평문)
		    return tempPass;
		}

		/** 임시 비밀번호 생성 */
		private String genTempPassword() {
		    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		    StringBuilder sb = new StringBuilder();
		    Random r = new Random();

		    for (int i = 0; i < 10; i++) {
		        sb.append(chars.charAt(r.nextInt(chars.length())));
		    }
		    return sb.toString();
		}

		/** SHA-256 암호화 */
		@Override
		public String encryptSHA256(String str) {
		    try {
		        MessageDigest md = MessageDigest.getInstance("SHA-256");
		        byte[] hash = md.digest(str.getBytes());
		        StringBuilder hex = new StringBuilder();
		        for (byte b : hash)
		            hex.append(String.format("%02x", b));
		        return hex.toString();
		    } catch (Exception e) {
		        throw new RuntimeException(e);
		    }
		}


}
