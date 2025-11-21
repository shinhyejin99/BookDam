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
 * Servlet implementation class NoticeDetail
 */
@WebServlet("/NoticeDetail.do")
public class NoticeDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String noticeIdStr = request.getParameter("noticeId");

		if (noticeIdStr == null || noticeIdStr.isEmpty()) {
			response.sendRedirect("NoticeList.do");
			return;
		}
		
		int noticeId = Integer.parseInt(noticeIdStr);
		INoticeService service = NoticeServiceImpl.getService();
		NoticeVO vo = service.getNoticeById(noticeId);
		
		if (vo == null) {
			response.sendRedirect("NoticeList.do");
			return;
		}
		
		request.setAttribute("notice", vo);
		request.getRequestDispatcher("/notice/noticeDetail.jsp").forward(request, response);
	}

}
