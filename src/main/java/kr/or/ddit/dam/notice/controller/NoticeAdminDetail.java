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
 * Servlet implementation class NoticeAdminDetail
 */
@WebServlet("/NoticeAdminDetail.do")
public class NoticeAdminDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeAdminDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//파라미터
		int noticeId = Integer.parseInt(request.getParameter("noticeId"));
		
		//서비스 객체
		INoticeService service = NoticeServiceImpl.getService();
		
		NoticeVO nvo = service.getNoticeById(noticeId);
		if(nvo == null) {
			response.sendRedirect(request.getContextPath() + "/NoticeAdminList.do?error=notfound");
			return;
		}
		
		request.setAttribute("notice", nvo);
		request.getRequestDispatcher("/notice/noticeAdminDetail.jsp").forward(request, response);
	}

}
