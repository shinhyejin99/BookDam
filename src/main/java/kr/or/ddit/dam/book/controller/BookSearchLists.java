package kr.or.ddit.dam.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.util.StreamData;
import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.PageVO;
import kr.or.ddit.dam.vo.SearchVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class BookSearchLists
 */
@WebServlet("/BookSearchLists.do")
public class BookSearchLists extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public BookSearchLists() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 전송된 직렬화된 데이터 읽기(가져오기) - util에 있는 StreamData 이용
		// {page : 1, stype : "", sword=""}
		String reqData = StreamData.getChange(request);
		
		System.out.println("reqData: " + reqData);
		
		// 역직렬화 - 자바 객체로 바꾸기
		Gson gson = new Gson();
		SearchVO svo = gson.fromJson(reqData, SearchVO.class); //reqData를 SearchVO타입으로 바꿔라
		// svo에 데이터 들어있음 : {page : 1, stype : "", sword="", sortType=""}
		
		//--------
		
		// service 객체 얻기
		IBookService service = BookServiceImpl.getInstance();
		
		// 페이지정보 가져오기(먼저 해야함) -> service 메소드 호출 - 결과값 얻기
		// service의 getPageInfo 호출
		PageVO pvo = service.getPageInfo(svo.getPage(), svo.getStype(), svo.getSword());
		// pvo : start, end, startPage, endPage, totalPage

		// 전체 검색 결과 수 가져오기 - 총 OO권 검색됐습니다.
		Map<String, Object> countMap = new HashMap<String, Object>();
		countMap.put("stype", svo.getStype());
		countMap.put("sword", svo.getSword());
		// int totalCount = service.getSearchCounts(countMap); // stype, sword를 getSearchCounts의 파라미터로
		int totalCount = service.getSearchCounts(svo); // stype, sword를 getSearchCounts의 파라미터로
		
		// 검색된 도서 리스트 가져오기 위한 쿼리 수행
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", pvo.getStart());
		map.put("end", pvo.getEnd());
		map.put("stype", svo.getStype());
		map.put("sword", svo.getSword());
		map.put("sortType", svo.getSortType()); // 추가 - 정렬 카테고리 (판매인기순, 리뷰수, 최신순)
		
		// list객체에 담기
		List<BookVO> list = service.searchBooks(map); // sql문 수행(동적쿼리)
		
		// 결과값을 request에 저장
		request.setAttribute("listvalue", list);
		
		// 페이지 정보도 저장
		request.setAttribute("spage", pvo.getStartPage());
		request.setAttribute("epage", pvo.getEndPage());
		request.setAttribute("tpage", pvo.getTotalPage());
		request.setAttribute("totalCount", totalCount);
		
		// View 페이지로 이동-jsp
		request.getRequestDispatcher("/bookSearchView/bookSearchView.jsp").forward(request, response);

	}
}