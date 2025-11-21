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

/**
 * Servlet implementation class EventList
 */
@WebServlet("/EventList.do")
public class EventList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		IEventService service = EventServiceImpl.getService();
		
		List<EventVO> list = service.getAllEvents(new HashMap<>());
		request.setAttribute("eventList", list);
		
		request.getRequestDispatcher("/event/eventList.jsp").forward(request, response);
	}

}
