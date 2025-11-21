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

/**
 * Servlet implementation class EventAdminDetail
 */
@WebServlet("/EventAdminDetail.do")
public class EventAdminDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventAdminDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//파라미터
		int eventId = Integer.parseInt(request.getParameter("eventId"));
		
		//서비스 객체
		IEventService service = EventServiceImpl.getService();
		
		EventVO evo = service.getEventById(eventId);
		if(evo == null) {
			response.sendRedirect(request.getContextPath() + "/EventAdminList.do?error=notfound");
			return;
		}
		
		request.setAttribute("vo", evo);
		
		request.getRequestDispatcher("/event/eventAdminDetail.jsp").forward(request, response);
	}

}
