package kr.or.ddit.dam.event.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.event.service.EventServiceImpl;
import kr.or.ddit.dam.event.service.IEventService;
import kr.or.ddit.dam.vo.EventVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class EventAdminList
 */
@WebServlet("/EventAdminList.do")
public class EventAdminList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventAdminList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//서비스 객체
		IEventService service = EventServiceImpl.getService();
		
		//파라미터
		Map<String, Object> map = new HashMap<>();
		
		//서비스 호출
		List<EventVO> eventList = service.getAllEvents(map);
		
		//결과 저장
		request.setAttribute("eventList", eventList);
		
		//포워딩
		request.getRequestDispatcher("/event/eventAdminList.jsp").forward(request, response);
	}

}
