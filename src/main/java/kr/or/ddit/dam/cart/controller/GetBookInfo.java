package kr.or.ddit.dam.cart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.vo.BookVO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class GetBookInfo
 */
@WebServlet("/GetBookInfo.do")
public class GetBookInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetBookInfo() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Long book_no = Long.parseLong(request.getParameter("book_no"));

		IBookService service = BookServiceImpl.getInstance();
		BookVO book = service.getBookDetail(book_no);
		
		request.setAttribute("book", book);
		
		request.getRequestDispatcher("/cartDetailView/book.jsp").forward(request, response);
	}

}
