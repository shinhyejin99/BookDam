package kr.or.ddit.dam.notice.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.notice.service.INoticeService;
import kr.or.ddit.dam.notice.service.NoticeServiceImpl;
import kr.or.ddit.dam.vo.NoticeVO;

import java.io.IOException;

/**
 * Servlet implementation class NoticeAdminDelete
 */
@WebServlet("/NoticeAdminDelete.do")
public class NoticeAdminDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeAdminDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String noticeIdStr = request.getParameter("noticeId");
		if(noticeIdStr == null || noticeIdStr.trim().isEmpty()) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Id 누락");
			return;
		}
		
		//삭제할 id추출
		int noticeId = Integer.parseInt(noticeIdStr);
		
		//service객체 얻기
		INoticeService service = NoticeServiceImpl.getService();
		
		//service메소드 호출
		int res  = service.deleteNotice(noticeId);
		
		if(res > 0) {
			//삭제성공
			response.sendRedirect(request.getContextPath() + "/NoticeAdminList.do");
			return;
		}else {
			//삭제실패
			NoticeVO vo = service.getNoticeById(noticeId);
			request.setAttribute("vo", vo);
			request.setAttribute("error", "삭제실패");
			request.setAttribute("noticeId", noticeId);
			request.getRequestDispatcher("/notice/noticeAdminList.jsp").forward(request, response);
			
		}
	}

}
