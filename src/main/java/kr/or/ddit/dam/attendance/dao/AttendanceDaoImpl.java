package kr.or.ddit.dam.attendance.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.AttendanceVO;
import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class AttendanceDaoImpl implements IAttendanceDao {

	// 싱글톤 설정
	private static IAttendanceDao dao;
	private AttendanceDaoImpl() {
	}
	
	public static IAttendanceDao getInstance() {
		if (dao == null) dao = new AttendanceDaoImpl();
		return dao;
	}
	// 싱글톤 설정 끝--------
	
	
	// 오늘 출석여부 체크
	@Override
	public int isTodayAttended(String mem_mail) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("attendance.todayAttendCheck", mem_mail);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 출석 테이블에 insert 메소드
	@Override
	public int insertAttendance(AttendanceVO atvo) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.insert("attendance.insertAttendance", atvo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// Member 테이블에 마일리지 컬럼 update
	@Override
	public int updateMemMileage(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.update("attendance.updateMemMileage", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 마일리지 테이블에 insert
	@Override
	public int insertMileage(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.insert("attendance.insertMileage", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 출석 현황 데이터 가져오기
	@Override
	public List<String> loadAttendanceData(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		List<String> list = null;
			
		try {
			list = session.selectList("attendance.loadAttendanceData", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return list;
	}	
}
