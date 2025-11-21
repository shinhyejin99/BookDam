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
 * Servlet implementation class ReviewUpdate
 */
@WebServlet("/ReviewUpdate.do")
public class ReviewUpdate extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewUpdate() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String reqData = StreamData.getChange(request);
		System.out.println("reqData : " + reqData);
		
		Gson gson = new Gson();
		ReviewVO rvo = gson.fromJson(reqData, ReviewVO.class);
		
		// 서비스 객체
		IReviewService service = ReviewServiceImpl.getInstance();
		
		// 비속어 메소드 실행
		List<BadwordVO> blist = service.selectBadword();
		String rContent = rvo.getRv_content(); // 수정된 리뷰 내용 가져오기
		
		// 수정된 내용에 비속어 포함 체크하기
		for(BadwordVO bword : blist) {
			if(rContent.contains(bword.getBword())) {
				response.getWriter().print("{\"flag\":\"❌ 비속어가 포함되어 있어 리뷰를 수정할 수 없습니다 ❌\"}");
				return; // 비속어가 포함되어 있으면 여기서 종료
			}
		}

		int res = service.updateReview(rvo);
		
		// 포워드
		request.setAttribute("result", res);
		request.getRequestDispatcher("/bookDetail/result.jsp").forward(request, response);
		
	}

}
