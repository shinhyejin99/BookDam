package kr.or.ddit.dam.review.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.review.service.IReviewService;
import kr.or.ddit.dam.review.service.ReviewServiceImpl;
import kr.or.ddit.dam.util.StreamData;
import kr.or.ddit.dam.vo.BadwordVO;
import kr.or.ddit.dam.vo.ReviewVO;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

/**
 * Servlet implementation class ReportUpdate
 */
@WebServlet("/ReportUpdate.do")
public class ReportUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReportUpdate() {
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

		// 서비스 객체
		IReviewService service = ReviewServiceImpl.getInstance();
		
		int res = service.toggleReport(rvo); // 어떤 메소드 쓰는지 잘 확인하기!!!!
		
		// 포워드
		request.setAttribute("result", res);
		request.getRequestDispatcher("/bookDetail/result.jsp").forward(request, response);
		
	}
}
