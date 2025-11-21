package kr.or.ddit.dam.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class BookCategory
 */
@WebServlet("/BookCategory.do")
public class BookCategory extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookCategory() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		IBookService  service = BookServiceImpl.getInstance();
		
		List<String>  categoryList = service.getDistinctCategories();
		
		request.setAttribute("categoryList", categoryList);
		
		request.getRequestDispatcher("/bookManage/bookList.jsp").forward(request, response);
		 
	}

}
