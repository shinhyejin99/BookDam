package kr.or.ddit.dam.review.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.review.service.IReviewService;
import kr.or.ddit.dam.review.service.ReviewServiceImpl;
import kr.or.ddit.dam.util.StreamData;
import kr.or.ddit.dam.vo.PageVO;
import kr.or.ddit.dam.vo.ReviewVO;
import kr.or.ddit.dam.vo.SearchVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class ReviewList
 */
@WebServlet("/ReviewList.do")
public class ReviewList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ReviewList() {
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
		SearchVO svo = gson.fromJson(reqData, SearchVO.class); //reqData를 SearchVO타입으로 바꿔라
		
		IReviewService service = ReviewServiceImpl.getInstance();
		
		// 페이지 정보 가져오기
	    PageVO pvo = service.getPageInfo(svo.getPage(), svo.getBook_no());
	    
	    //  전체 리뷰 수 출력하기 위해 추가함
	    int totalAllCount = service.getReviewCount(svo.getBook_no());
	    
	    // 구매자 리뷰 수 출력하기 위해 추가함
	    Map<String, Object> buyerCountMap = new HashMap<>();
	    buyerCountMap.put("book_no", svo.getBook_no());
	    buyerCountMap.put("tabType", "buyer");
	    List<ReviewVO> buyerList = service.getReviewList(buyerCountMap);
	    int totalBuyerCount = buyerList.size(); 
	    // 구매자를 구분하기 위해 getReviewCount가 아니라 getReviewList 실행 후 사이즈 구해서 카운트한다.
	    
	    // 리뷰 리스트 가져오기 - Map 생성
	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("book_no", svo.getBook_no());
	    map.put("start", pvo.getStart());
	    map.put("end", pvo.getEnd());
	    map.put("tabType", svo.getTabType());
	    map.put("sortType", svo.getSortType());
	    map.put("mem_mail", svo.getMem_mail()); // 회원 좋아요/신고 여부
	    
	    // 리뷰 리스트 가져오기
	    List<ReviewVO> list = service.getReviewList(map);
	    
	    // 결과값을 request에 저장
	 	request.setAttribute("listvalue", list);
	 		
 		// 페이지 정보도 저장
	 	request.setAttribute("pageInfo", pvo);  // 이 부분 추가!
	 	
	 	// 리뷰 수 정보 보내기 - 추가!
	 	request.setAttribute("totalAllCount", totalAllCount);
	 	request.setAttribute("totalBuyerCount", totalBuyerCount);
 		
 		// View 페이지로 이동-jsp
 		request.getRequestDispatcher("/bookDetail/reviewListView.jsp").forward(request, response);
		
		
	}

}
