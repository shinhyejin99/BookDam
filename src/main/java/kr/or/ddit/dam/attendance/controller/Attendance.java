package kr.or.ddit.dam.attendance.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.attendance.service.AttendanceServiceImpl;
import kr.or.ddit.dam.attendance.service.IAttendanceService;
import kr.or.ddit.dam.util.StreamData;
import kr.or.ddit.dam.vo.AttendanceVO;
import kr.or.ddit.dam.vo.MemVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class Attendance
 */
@WebServlet("/Attendance.do")
public class Attendance extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Attendance() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 데이터 꺼내기
		String action = request.getParameter("action"); // = attendanceCheck (출석체크 버튼 눌렀다)
		String mem_mail = request.getParameter("mem_mail"); // = memMail (출석체크 버튼 누를 회원의 이메일(ID))
		String year = request.getParameter("year"); // 숫자 -> 문자로!
		String month = request.getParameter("month"); // 숫자 -> 문자로!
		
		// 서비스 객체 불러오기
		IAttendanceService service = AttendanceServiceImpl.getInstance();

		// 출석체크 눌렀을 때
		if("attendanceCheck".equals(action)) {
			
			// 보안 : 세션에서도 한번 더 체크
			HttpSession session = request.getSession();
			MemVO mvo = (MemVO)session.getAttribute("loginOk");
			
			// 로그인 회원 메일 =/= 세션 메일
			if(!mem_mail.equals(mvo.getMem_mail())) {
				response.getWriter().write("{\"flag\":\"잘못된 접근입니다\"}"); // 바로 jsp로
				return; // 돌아가! 끝!!
			}

			// 아직 오늘 출석체크를 하지 않았을 때
			// 총 메소드 실행(4가지 메소드 포함 메소드) => 출석체크 여부확인, 마일리지 지급, 출석 체크 테이블, 회원 테이블 업데이트 및 삽입
			// 좋아요 토글 기능 처럼 서비스에서 여러개의 dao 실행하는 형식으로 진행
			int processResult = service.processAttendance(mem_mail);
			
			// return -2 : 이미 출석했음
			// return mileage;  성공시 마일리지 반환
			// return 0;  실패		
			
			// processResult 그대로 전달하고 + mileage 추가
			request.setAttribute("result", processResult);
			
			if(processResult > 0) { // 출석체크 성공했을 때 => 출석 마일리지 보낸다
			    request.setAttribute("mileage", processResult);
			}
			request.getRequestDispatcher("/bookDetail/result.jsp").forward(request, response);
			
		// 출석체크 데이터 가져오기	
		} else if ("userAttendanceCheck".equals(action)) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("mem_mail", mem_mail);
			map.put("year", year);
			map.put("month", month);
			
			// 메소드 호출 - 날짜들만 가져오기 때문에 AttendanceVO가 아니라 String타입의 List로 !
			List<String> list = (List<String>) service.loadAttendanceData(map);

			request.setAttribute("listValue", list);
			request.getRequestDispatcher("/attendance/loadAttendanceDataView.jsp").forward(request, response);
		}
	}
}
