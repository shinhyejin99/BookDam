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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class ReviewInsert
 */
@WebServlet("/ReviewInsert.do")
public class ReviewInsert extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewInsert() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String reqData = StreamData.getChange(request);
		System.out.println("reqData: " + reqData);
		
		// 역직렬화
		Gson gson = new Gson();
		ReviewVO rvo = gson.fromJson(reqData, ReviewVO.class);
		// rv_content : 리뷰 내용
		
		// 서비스 객체
		IReviewService service = ReviewServiceImpl.getInstance();
		
		// 회원의 리뷰 중복 체크
		Map<String, Object> checkMap = new HashMap<String, Object>();
		checkMap.put("book_no", rvo.getBook_no());
		checkMap.put("mem_mail", rvo.getMem_mail());
		
		int check = service.reviewCheck(checkMap);
		if(check > 0) {
			response.getWriter().print("{\"flag\":\"이미 리뷰를 작성하셨습니다\"}");
			return; // 이미 리뷰를 썼으면 여기서 종료
		}
		System.out.println("회원 중복리뷰 체크 결과: " + check);
		
		
		// 비속어 체크
		List<BadwordVO> blist = service.selectBadword();
		String rContent = rvo.getRv_content();
		
		// 비속어 포함되어 있는지 체크
		for(BadwordVO badword : blist) {
			if(rContent.contains(badword.getBword())) {
				response.getWriter().print("{\"flag\":\"❌ 비속어가 포함되어 있어 리뷰를 등록할 수 없습니다 ❌\"}");
				return; // 비속어가 포함되어 있으면 여기서 종료
			}
		}

		// 리뷰 작성(삽입) - 리뷰 중복과 비속어가 포함되어 있지 않을 때 실행
		int res = service.insertReview(rvo);
		
		request.setAttribute("result", res);
		request.getRequestDispatcher("/bookDetail/result.jsp").forward(request, response);
	}
}
