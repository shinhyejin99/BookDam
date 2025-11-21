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
 * Servlet implementation class EventAdminDelete
 */
@WebServlet("/EventAdminDelete.do")
public class EventAdminDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EventAdminDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String eventIdStr = request.getParameter("eventId");
		if(eventIdStr == null || eventIdStr.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Id 누락");
			return;
		}
		//삭제할 eventId 추출
		int eventId = Integer.parseInt(eventIdStr);
		
		//service 객체 얻기
		IEventService service = EventServiceImpl.getService();
		
		//service메소드 호출
		int res = service.deleteEvent(eventId);
		
		if(res > 0) {
			//삭제성공 후
			response.sendRedirect(request.getContextPath() + "/EventAdminList.do");
			return;
		}else {
			//삭제실패
		    EventVO vo = service.getEventById(eventId);
		    request.setAttribute("vo", vo);
			request.setAttribute("error", "삭제실패");
			request.setAttribute("eventId", eventId);
			request.getRequestDispatcher("/event/eventAdminDetail.jsp").forward(request, response);
		}
		
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}
}
