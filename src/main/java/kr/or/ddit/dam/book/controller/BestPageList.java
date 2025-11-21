package kr.or.ddit.dam.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.vo.BookVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class BestPageList
 */
@WebServlet("/BestPageList.do")
public class BestPageList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BestPageList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String limitStr = request.getParameter("limit");
		int limit = (limitStr != null) ? Integer.parseInt(limitStr) : 10; // 기본값 10개
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("limit", limit);
		
		IBookService service = BookServiceImpl.getInstance();
		List<BookVO> list = service.getBestsellerList(map);
		
		
		System.out.println("=== 베스트셀러 조회 결과 ===");
		System.out.println("service: " + service);
		System.out.println("map: " + map);
		System.out.println("list: " + list);
		System.out.println("list size: " + (list != null ? list.size() : "null"));
		
		request.setAttribute("listValue", list);
		request.getRequestDispatcher("/bookSearch/bookBestsellerView.jsp").forward(request, response);

	}

}
