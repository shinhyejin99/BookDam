package kr.or.ddit.dam.review.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.review.service.IReviewService;
import kr.or.ddit.dam.review.service.ReviewServiceImpl;
import kr.or.ddit.dam.util.StreamData;
import kr.or.ddit.dam.vo.ReviewVO;

import java.io.IOException;
import java.util.stream.Stream;

import com.google.gson.Gson;

/**
 * Servlet implementation class LikeUpdate
 */
@WebServlet("/LikeUpdate.do")
public class LikeUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LikeUpdate() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String reqData = StreamData.getChange(request);
		System.out.println("reqData: " + reqData);
		
		Gson gson = new Gson();
		ReviewVO rvo = gson.fromJson(reqData, ReviewVO.class);
		
		IReviewService service = ReviewServiceImpl.getInstance();
		int res = service.toggleLike(rvo);
		
		request.setAttribute("result", res);
		
		request.getRequestDispatcher("/bookDetail/result.jsp").forward(request, response);
		
	}

}
