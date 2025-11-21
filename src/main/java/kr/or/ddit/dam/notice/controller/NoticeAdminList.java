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
import java.util.Map;

/**
 * Servlet implementation class NoticeAdminList
 */
@WebServlet("/NoticeAdminList.do")
public class NoticeAdminList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NoticeAdminList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		INoticeService service = NoticeServiceImpl.getService();
		
		Map<String, Object> map = new HashMap<>();
        List<NoticeVO> list = service.getAllNotice(map);
        
        request.setAttribute("noticeList", list);
        request.getRequestDispatcher("/notice/noticeAdminList.jsp").forward(request, response);
    }
}


