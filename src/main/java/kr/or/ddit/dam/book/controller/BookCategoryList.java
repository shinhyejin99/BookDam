package kr.or.ddit.dam.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.PageVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class BookCategoryList
 */
@WebServlet("/BookCategoryList.do")
public class BookCategoryList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookCategoryList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String category = request.getParameter("category");
		String pageStr = request.getParameter("page");
		String sortType = request.getParameter("sortType");

		int page = (pageStr != null) ? Integer.parseInt(pageStr) : 1;

		// 2. PageVO 생성 (카테고리용으로 수정 필요)
		IBookService service = BookServiceImpl.getInstance();
		PageVO pvo = service.getPageInfoByCategory(page, category); // 새로 만들어야 함

		// 3. 전체 카테고리 도서 수 가져오기
		int totalCount = service.getCategoryBookCount(category);

		// 4. 카테고리별 도서 리스트 가져오기
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", pvo.getStart());
		map.put("end", pvo.getEnd());
		map.put("category", category);
		map.put("sortType", sortType != null ? sortType : "popularity"); // 기본값

		List<BookVO> list = service.getBooksByCategory(map); //

		// 5. 결과값 저장 (동일)
		request.setAttribute("listvalue", list);
		request.setAttribute("spage", pvo.getStartPage());
		request.setAttribute("epage", pvo.getEndPage());
		request.setAttribute("tpage", pvo.getTotalPage());
		request.setAttribute("totalCount", totalCount);
		
		// View 페이지로 이동-jsp
		request.getRequestDispatcher("/bookSearch/bookCategoryListView.jsp").forward(request, response);
	}

}
