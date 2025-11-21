package kr.or.ddit.dam.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.review.service.IReviewService;
import kr.or.ddit.dam.review.service.ReviewServiceImpl;
import kr.or.ddit.dam.vo.BookVO;

import java.io.IOException;

/**
 * Servlet implementation class BookDetail
 */
@WebServlet("/BookDetail.do")
public class BookDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String bookNoStr = request.getParameter("bookNo");
        Long bookNo = Long.parseLong(bookNoStr);

        IBookService service = BookServiceImpl.getInstance();
        BookVO bvo = service.getBookDetail(bookNo);
        
        // 베스트셀러 랭킹 가져오기
        int bestRank = service.getBestsellerRank(bookNo);

        request.setAttribute("book", bvo);
		request.setAttribute("bestRank", bestRank);
		
        request.getRequestDispatcher("/bookDetail/bookDetail.jsp").forward(request, response);
	}
}
