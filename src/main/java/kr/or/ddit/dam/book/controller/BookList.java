package kr.or.ddit.dam.book.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
 * Servlet implementation class BookList
 */
@WebServlet("/BookList.do")
public class BookList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 request.setCharacterEncoding("UTF-8");
	 
		 //직렬화 전송데이타 읽기 - 최초 실행시 에는 전송데이타가 없다
		 String reqData = StreamData.getChange(request);
		 System.out.println("reqData==" + reqData);
		 
		 SearchVO svo = null;
		 
		 Gson gson =new Gson(); 
		 svo = gson.fromJson(reqData, SearchVO.class);
		 
	
		 
		 IBookService  service = BookServiceImpl.getInstance();
		 
		 //페이지 정보 구하기
		 PageVO  pvo= service.getPageInfo(svo);
		//startPage, endPage, start, end, totalPage
		 
		
		 
		 //bookList가져오기
		 Map<String, Object> map = new HashMap<>();
		map.put("start", pvo.getStart());
		map.put("end", pvo.getEnd());
		map.put("stype", svo.getStype());
		map.put("sword", svo.getSword());
		map.put("category", svo.getCategory()); 
		map.put("minPrice", svo.getMinPrice());
		map.put("maxPrice", svo.getMaxPrice());
		map.put("minStock", svo.getMinStock());
		map.put("maxStock", svo.getMaxStock());
		map.put("startDate",svo.getStartDate()); 
		map.put("endDate", svo.getEndDate());
		
	     List<BookVO> bookList = service.searchBook(map);
		 System.out.println(" bookList= " + bookList);
		
		request.setAttribute("SearchVO", svo);
		request.setAttribute("PageVO", pvo);
		request.setAttribute("bookList", bookList);
		 
	  request.getRequestDispatcher("/bookManage/listView.jsp").forward(request,response);
			
	}

}