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
import java.security.Provider.Service;

/**
 * Servlet implementation class EventDetail
 */
@WebServlet("/EventDetail.do")
public class EventDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String eventIdStr = request.getParameter("eventId");
		
		if(eventIdStr == null || eventIdStr.isEmpty()) {
			response.sendRedirect("EventList.do");
			return;
		}
		int eventId = Integer.parseInt(eventIdStr);
		IEventService service = EventServiceImpl.getService();
		EventVO vo = service.getEventById(eventId);
		
		if(vo == null) {
			response.sendRedirect("EventList.do");
			return;
		}
		request.setAttribute("event", vo);
		request.getRequestDispatcher("/event/eventDetail.jsp").forward(request, response);
	}

}
