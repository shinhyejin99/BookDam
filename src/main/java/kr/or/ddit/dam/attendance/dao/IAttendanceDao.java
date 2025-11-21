package kr.or.ddit.dam.attendance.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.AttendanceVO;

public interface IAttendanceDao {
	
	// 회원의 출석체크 여부 체크 메소드
	public int isTodayAttended(String mem_mail);
	
	// 출석 테이블에 insert 메소드
	public int insertAttendance(AttendanceVO atvo);
	
	// 회원 테이블에 마일리지 update 메소드
	public int updateMemMileage(Map<String, Object> map);
	
	// 마일리지 테이블에 insert 메소드
	public int insertMileage(Map<String, Object> map);
	
	// 출석 데이터 가져오기
	public List<String> loadAttendanceData(Map<String, Object> map);
}
