package kr.or.ddit.dam.event.controller;

import java.io.IOException;
import java.time.LocalDate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.event.service.EventServiceImpl;
import kr.or.ddit.dam.event.service.IEventService;
import kr.or.ddit.dam.vo.EventVO;

/**
 * Servlet implementation class EventAdminWrite
 */
@WebServlet("/EventAdminWrite.do")
public class EventAdminWrite extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventAdminWrite() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.sendRedirect(request.getContextPath() + "/event/eventAdminWrite.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// 1. 파라미터 수집
				String title = request.getParameter("title");
				String content = request.getParameter("content");
				String eventDate = request.getParameter("eventDate"); // yyyy-MM-dd
				String imgFile = request.getParameter("imgFile");     // 이미지 파일명
				
				
				// 2. VO 객체 구성
				EventVO vo = new EventVO();
				vo.setEventTitle(title);
				vo.setEventContent(content);
				vo.setEventDate(eventDate);                       // 작성일
				vo.setEventOpenDate(LocalDate.now().toString()); // 공개일 → 현재날짜
				vo.setEventType(imgFile);                         // 이미지파일명 저장 (eventType으로 사용)

				// 3. 서비스 호출
				IEventService service = EventServiceImpl.getService();
				int result = service.insertEvent(vo); // EVENT + EVENT_NOMAL 동시 등록

				// 4. 결과 처리
				if (result > 0) {
					response.sendRedirect(request.getContextPath() + "/EventAdminList.do");
				} else {
					response.sendRedirect(request.getContextPath() + "/event/eventAdminWrite.jsp?error=fail");
				}
			}
	}
