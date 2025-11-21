package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.vo.MemVO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class MemberSearch
 */
@WebServlet("/MemberSearch.do")
public class MemberSearch extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public MemberSearch() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 request.setCharacterEncoding("UTF-8");
		
		//값 받기
		String searchType = request.getParameter("searchType");
	    String searchValue = request.getParameter("searchValue");
	    String birthStart = request.getParameter("birthStart");
	    String birthEnd = request.getParameter("birthEnd");
	    String joinStart = request.getParameter("joinStart");
	    String joinEnd = request.getParameter("joinEnd");
	    String addr = request.getParameter("address");  
	    String grade = request.getParameter("grade");
		
		//확인용
	    System.out.println("검색타입: " + searchType);
	    System.out.println("검색값: " + searchValue);
	    System.out.println("생년월일: " + birthStart + " ~ " + birthEnd);
	    System.out.println("가입일: " + joinStart + " ~ " + joinEnd);
	    System.out.println("주소: " + addr);
	    System.out.println("등급: " + grade);

	    
	    // IMemService 메서드 호출
	    IMemService memService = new MemServiceImpl();
	    List<MemVO> memList = memService.searchMember(
	        searchType, searchValue, birthStart, birthEnd, joinStart, joinEnd, addr, grade);
 
	 // 결과를 JSP로 전달
	    request.setAttribute("memList", memList);
	 	// request.getRequestDispatcher("/admin/adminMain.jsp").forward(request, response);
	    request.getRequestDispatcher("/memberView/memberSearch.jsp").forward(request, response);
	}
}