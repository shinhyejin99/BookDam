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
 * Servlet implementation class NoticeAdminWrite
 */
@WebServlet("/NoticeAdminWrite.do")
public class NoticeAdminWrite extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeAdminWrite() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String title = request.getParameter("noticeTitle");
		String content = request.getParameter("noticeContent");
		String date = request.getParameter("noticeDate");
		
		NoticeVO vo = new NoticeVO();
		vo.setNoticeTitle(title);
		vo.setNoticeContent(content);
		vo.setNoticeDate(date);
		
		INoticeService service = NoticeServiceImpl.getService();
		int result = service.insertNotice(vo);
		
		response.sendRedirect(request.getContextPath() + "/NoticeAdminList.do");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
