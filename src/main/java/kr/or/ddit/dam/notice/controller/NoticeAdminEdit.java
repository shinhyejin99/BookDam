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
 * Servlet implementation class NoticeAdminEdit
 */
@WebServlet("/NoticeAdminEdit.do")
public class NoticeAdminEdit extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeAdminEdit() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int noticeId = Integer.parseInt(request.getParameter("noticeId"));
		INoticeService service = NoticeServiceImpl.getService();
		NoticeVO vo = service.getNoticeById(noticeId);
		
		request.setAttribute("notice", vo);
		request.getRequestDispatcher("/notice/noticeAdminEdit.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int noticeId = Integer.parseInt(request.getParameter("noticeId"));
		String title = request.getParameter("noticeTitle");
		String content = request.getParameter("noticeContent");
		
		NoticeVO vo = new NoticeVO();
		vo.setNoticeId(noticeId);
		vo.setNoticeTitle(title);
		vo.setNoticeContent(content);
		
		INoticeService service = NoticeServiceImpl.getService();
		int res = service.updateNotice(vo);
		
		response.sendRedirect(request.getContextPath() + "/NoticeAdminList.do");
	}

}
