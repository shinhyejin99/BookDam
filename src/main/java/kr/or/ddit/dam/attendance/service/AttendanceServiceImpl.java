package kr.or.ddit.dam.attendance.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.ibatis.session.SqlSessionFactory;

import kr.or.ddit.dam.attendance.dao.AttendanceDaoImpl;
import kr.or.ddit.dam.attendance.dao.IAttendanceDao;
import kr.or.ddit.dam.vo.AttendanceVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class AttendanceServiceImpl implements IAttendanceService {

	// 싱글톤 설정
	private SqlSessionFactory factory = MybatisUtil.getSqlSessionFactory();

	private static IAttendanceService service;
	private IAttendanceDao dao;
	
	private AttendanceServiceImpl() {
		dao = AttendanceDaoImpl.getInstance();
	}
	
	public static IAttendanceService getInstance() {
		if(service == null) service = new AttendanceServiceImpl();
		return service;
	}
	// 싱글톤 설정 끝------------- 
	
	
	// 오늘 출석체크 여부 확인
	@Override
	public int isTodayAttended(String mem_mail) {
		return dao.isTodayAttended(mem_mail);
	}

	@Override
	public int insertAttendance(AttendanceVO atvo) {
		return dao.insertAttendance(atvo);
	}

	@Override
	public int updateMemMileage(Map<String, Object> map) {
		return dao.updateMemMileage(map);
	}

	@Override
	public int insertMileage(Map<String, Object> map) {
		return dao.insertMileage(map);
	}

	// 서비스에만 있는 비즈니스
	@Override
	public int processAttendance(String mem_mail) {
		
		// 1. 체크 (내부에서)
	    if(dao.isTodayAttended(mem_mail) == 1) {
	        return -2; // 이미 출석했음
	    }
	    
	    try {
	    	// 랜덤 마일리지 생성
	    	int mileage = generateRandomMileage();
	    	
	    	// 출석 테이블 업데이트에 필요한 atvo 생성
	    	AttendanceVO atvo = new AttendanceVO();
	    	atvo.setMem_mail(mem_mail);
	    	atvo.setAttendance_mileage_amt(mileage);
	    	
	    	// Map으로 파라미터 전달 - 2개 메소드에 필요함
	    	Map<String, Object> map = new HashMap<String, Object>();
	    	map.put("mem_mail", mem_mail);
	    	map.put("attendance_mileage_amt", mileage);
	    	map.put("mileageType", "출석체크");

	    	// ** 3개 dao 실행 **
	    	// 2. 출석 테이블
	    	int insertAttendResult = dao.insertAttendance(atvo);
	    	if(insertAttendResult == 0) return 0; // 실패시 즉시 리턴

		    // 3. 회원 업데이트
			/*
			 * int updateMailageResult = dao.updateMemMileage(map); if(updateMailageResult
			 * == 0) return 0; // 실패시 즉시 리턴
			 */	    	
		    // 4. 마일리지 테이블 
	    	int insertMileageResult = dao.insertMileage(map);
	    	if(insertMileageResult == 0) return 0; // 실패시 즉시 리턴
	    	
	    	return mileage; // 성공시 마일리지 반환
	    	
	    } catch (Exception e) {
			e.printStackTrace();
			return 0; // 실패 시 0 반환
		}
	}
	
	// 랜덤 마일리지 생성
	private int generateRandomMileage() {
		int[] mileage = {20, 30, 50, 100, 200, 300, 500, 1000};
	    Random random = new Random();
	    
	    // 랜덤으로 나올 마일리지들을 배열로 생성하고 
	    // random 함수를 이용해서 저 배열 길이의 숫자(8개) 즉, 0~7 번째의 숫자 중 하나를 뽑아서 
	    // ex) mileage[7] 이면 1000 마일리지를 리턴한다.
	    return mileage[random.nextInt(mileage.length)];
	}

	// 출석 현황 가져오기
	@Override
	public List<String> loadAttendanceData(Map<String, Object> map) {
		return dao.loadAttendanceData(map);
	}

}
