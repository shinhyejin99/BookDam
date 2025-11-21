package kr.or.ddit.dam.mem.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.vo.MileageVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class MemDaoImpl implements IMemDao {

	// 싱글톤
	private static IMemDao dao;

	public static IMemDao getDao() {

		if (dao == null)
			dao = new MemDaoImpl();

		return dao;
	}

	private MemDaoImpl() {

	}

	@Override
	public List<MemVO> getAllMember() {
		SqlSession session = MybatisUtil.getInstance();

		List<MemVO> list = null;

		try {

			list = session.selectList("member.getAllMember");

		} catch (Exception e) {
			e.printStackTrace();

		} finally {

			if (session != null) {

				session.commit();
				session.close();
			}

		}
		return list;
	}

	@Override
	public MemVO loginMember(MemVO vo) {

		SqlSession session = MybatisUtil.getInstance();

		MemVO mvo = null;

		try {

			mvo = session.selectOne("member.loginMember", vo);

		} catch (Exception e) {
			e.printStackTrace();

		} finally {

			if (session != null) {

				session.commit();
				session.close();
			}

		}
		return mvo;
	}

	@Override
	public String mailcheck(String mail) {

		SqlSession session = MybatisUtil.getInstance();

		String mvo = null;

		try {

			mvo = session.selectOne("member.mailcheck", mail);

		} catch (Exception e) {
			e.printStackTrace();

		} finally {

			if (session != null) {

				session.commit();
				session.close();
			}

		}
		return mvo;
	}

	@Override
	public String nicknamecheck(String nickname) {

		SqlSession session = MybatisUtil.getInstance();

		String mvo = null;

		try {

			mvo = session.selectOne("member.nicknamecheck", nickname);

		} catch (Exception e) {
			e.printStackTrace();

		} finally {

			if (session != null) {

				session.commit();
				session.close();
			}

		}
		return mvo;
	}

	@Override
	public int insertMember(MemVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;

		try {
			if (vo.getMem_join() == null) {
				vo.setMem_join(new java.sql.Date(System.currentTimeMillis()));
			}
			if (vo.getMem_resign() == null) {
				vo.setMem_resign("N"); // 기본값 설정
			}
			res = session.insert("member.insertMember", vo);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.commit();
				session.close();
			}
		}

		return res;
	}

	@Override
	public String PassFind(String mail, String bir) {

		SqlSession session = MybatisUtil.getInstance();
		String pass = null;

		try {
			pass = session.selectOne("member.PassFind", Map.of("mem_mail", mail, "mem_bir", bir));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.close();
			}
		}

		return pass;
	}

	@Override
	public MemVO selectMemberByEmail(String mem_mail) {

		SqlSession session = MybatisUtil.getInstance();
		MemVO vo = null;

		try {
			vo = session.selectOne("member.selectByEmail", mem_mail);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.close();
			}
		}

		return vo;
	}

	@Override
	public boolean checkPassword(String mem_pass, String mem_mail) {

		if (mem_pass == null || mem_mail == null)
			return true;

		SqlSession session = MybatisUtil.getInstance();
		boolean res = true;

		try {

			int count = session.selectOne("member.checkPassword", Map.of("mem_mail", mem_mail, "mem_pass", mem_pass));

			res = count > 0;
		} catch (Exception e) {
			e.printStackTrace();

		} finally {

			if (session != null) {
				session.close();
			}
		}

		return res;
	}

	@Override
	public int updateMember(MemVO mvo) {

		SqlSession session = MybatisUtil.getInstance();
		int cnt = 0;
		try {
			cnt = session.update("member.updateMember", mvo);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.commit();
				session.close();
			}
		}
		return cnt;
	}

	@Override
	public int resignMember(String mem_mail) {

		SqlSession session = MybatisUtil.getInstance();
		int cnt = 0;

		try {
			cnt = session.update("member.resignMember", mem_mail);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.commit();
				session.close();
			}
		}
		return cnt;

	}

	@Override
	public MemVO getMember(String mem_mail) {

		SqlSession session = MybatisUtil.getInstance();
		MemVO mvo = null;

		try {
			mvo = session.selectOne("member.getMember", mem_mail);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null)
				session.close();
		}

		return mvo;
	}

	// 환불 후 마일리지 업데이트하는 메소드
	@Override
	public int updateMileage(SqlSession sqlSession, Map<String, Object> memMap) {

		int cnt = 0;

		try {
			cnt = sqlSession.update("member.updateMileage", memMap);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// if (session != null) session.close();
		}

		return cnt;
	}

	// 환불 후 Mileage 테이블에 내역 insert
	@Override
	public int insertUsedMileageInfo(SqlSession sqlSession, Map<String, Object> memMap) {
		int cnt = 0;

		try {
			cnt = sqlSession.update("member.insertUsedMileageInfo", memMap);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// if (session != null) session.close();
		}

		return cnt;
	}

	// 환불 후 Mileage 테이블에 내역 insert
	@Override
	public int insertEarnedMileageInfo(SqlSession sqlSession, Map<String, Object> memMap) {
		int cnt = 0;

		try {
			cnt = sqlSession.update("member.insertEarnedMileageInfo", memMap);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			// if (session != null) session.close();
		}

		return cnt;
	}

	// 회원 별로 마일리지 내역을 얻어오는 메소드
	@Override
	public List<MileageVO> getMileageList(String mem_mail) {
		List<MileageVO> mileageList = null;

		SqlSession session = MybatisUtil.getInstance();

		try {
			mileageList = session.selectList("member.getMileageList", mem_mail);

		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}

		return mileageList;
	}

	@Override
	public List<MemVO> searchMember(Map<String, Object> paramMap) {
		SqlSession session = null;
		List<MemVO> memberList = null;

		try {
			// SqlSession을 받아옴 (매개변수로 받는 방식)
			session = MybatisUtil.getInstance();

			// 회원 검색 쿼리 실행
			memberList = session.selectList("member.searchMember", paramMap);
		} catch (Exception e) {
			// 예외 발생 시 스택 트레이스 출력
			e.printStackTrace();
		} finally {
			// 세션을 닫고 커밋 처리
			if (session != null) {
				session.close();
			}
		}

		return memberList; // 결과 반환
	}

	// 회원의 한 달 구매 금액을 조회하는 메소드
	@Override
	public int getMemMonthlyBuy(String mem_mail) {
		int monthlyBuy = 0;

		SqlSession session = MybatisUtil.getInstance();

		try {
			monthlyBuy = session.selectOne("member.getMemMonthlyBuy", mem_mail);

		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		return monthlyBuy;
	}

	// 구매금액에 따라 Member 테이블의 회원 등급 update
	@Override
	public int updateMemGrade(Map<String, Object> memMap) {
		int cnt = 0;

		SqlSession session = MybatisUtil.getInstance();

		try {
			cnt = session.update("member.updateMemGrade", memMap);

		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.commit();
			session.close();
		}
		return cnt;
	}

	@Override
	public int updateTempPassword(Map<String, String> map) {
		SqlSession session = MybatisUtil.getInstance();
		int cnt = 0;

		try {
			cnt = session.update("member.updateTempPassword", map);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.commit();
				session.close();
			}
		}
		return cnt;
	}

	@Override
	public String getMemberForPassFind(String mail, String bir) {
		SqlSession session = MybatisUtil.getInstance();
		String res = null;

		try {
			res = session.selectOne("member.getMemberForPassFind", Map.of("mem_mail", mail, "mem_bir", bir));
		} finally {
			session.close();
		}
		return res;
	}

}
