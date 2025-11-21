package kr.or.ddit.dam.event.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.event.service.EventServiceImpl;
import kr.or.ddit.dam.event.service.IEventService;
import kr.or.ddit.dam.vo.EventVO;

/**
 * Servlet implementation class EventAdminEdit
 */
@WebServlet("/EventAdminEdit.do")
public class EventAdminEdit extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventAdminEdit() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int eventId = Integer.parseInt(request.getParameter("eventId"));
		IEventService service = EventServiceImpl.getService();
		EventVO vo = service.getEventById(eventId);

		request.setAttribute("event", vo);
		request.getRequestDispatcher("/event/eventAdminEdit.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int eventId = Integer.parseInt(request.getParameter("eventId"));
		String title = request.getParameter("eventTitle");
		String type = request.getParameter("eventType");
		String content = request.getParameter("eventContent");

		EventVO vo = new EventVO();
		vo.setEventId(eventId);
		vo.setEventTitle(title);
		vo.setEventType(type);
		vo.setEventContent(content);
		
		IEventService service = EventServiceImpl.getService();
		int res1 = service.updateEvent(vo);         // 공통 테이블

		response.sendRedirect(request.getContextPath() + "/EventAdminList.do");
	}

}
