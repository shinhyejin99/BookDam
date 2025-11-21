package kr.or.ddit.dam.review.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.review.service.IReviewService;
import kr.or.ddit.dam.review.service.ReviewServiceImpl;

import java.io.IOException;
import java.net.Authenticator.RequestorType;

/**
 * Servlet implementation class ReviewDelete
 */
@WebServlet("/ReviewDelete.do")
public class ReviewDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		int rvId = Integer.parseInt(request.getParameter("rv_id"));
		
		IReviewService service = ReviewServiceImpl.getInstance();
		int res = service.deleteReview(rvId);
		
		request.setAttribute("result", res);
		request.getRequestDispatcher("/bookDetail/result.jsp").forward(request, response);
	}
}
