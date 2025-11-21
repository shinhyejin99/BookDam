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
import java.util.HashMap;
import java.util.List;

/**
 * Servlet implementation class NoticeList
 */
@WebServlet("/NoticeList.do")
public class NoticeList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		INoticeService service = NoticeServiceImpl.getService();
		
		List<NoticeVO> list = service.getAllNotice(new HashMap<>());
		request.setAttribute("noticeList", list);
		
		request.getRequestDispatcher("/notice/noticeList.jsp").forward(request, response);
	}

}
