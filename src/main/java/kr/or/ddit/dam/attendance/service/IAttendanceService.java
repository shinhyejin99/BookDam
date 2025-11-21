package kr.or.ddit.dam.attendance.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.AttendanceVO;

public interface IAttendanceService {

	// 회원의 출석체크 여부 체크 메소드
	public int isTodayAttended(String mem_mail);
	
	// 출석 테이블에 insert 메소드
	public int insertAttendance(AttendanceVO atvo);
	
	// 회원 테이블에 마일리지 update 메소드
	public int updateMemMileage(Map<String, Object> map);
	
	// 마일리지 테이블에 insert 메소드
	public int insertMileage(Map<String, Object> map);
	
	// 서비스에서만
	// 출석 처리 (출석체크 여부 + 출석 기록(insert) + 마일리지 지급 한번에(update) + 마일리지)
	public int processAttendance(String mem_mail);
	
	// 출석 데이터 가져오기
	public List<String> loadAttendanceData(Map<String, Object> map);
}
