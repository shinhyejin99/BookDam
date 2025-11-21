package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.vo.CustVO;

import java.io.IOException;

/**
 * Servlet implementation class DeleteMember
 */
@WebServlet("/DeleteMember.do")
public class DeleteMember extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteMember() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		System.out.println("DeleteMember 서블릿 호출됨");
		
		
		HttpSession session = request.getSession(false);


        if (session== null || session.getAttribute("loginCust") == null) {
            response.sendRedirect(request.getContextPath() + "/log/login.jsp");
            return;
        }

        CustVO loginCust = (CustVO) session.getAttribute("loginCust");
        
        // 로그인된 사용자 이메일 가져오기
        String mem_mail = loginCust.getCust_id();
        System.out.println("탈퇴 요청 이메일: " + mem_mail);

        //탈퇴처리
        
	    IMemService memService = MemServiceImpl.getService();
	    int memres = memService.resignMember(mem_mail);

	    response.setContentType("application/json; charset=UTF-8");
	    
	    if (memres > 0) {
	    	
	    	 try {
	             session.invalidate(); // 세션 한 번만 무효화
	         } catch (IllegalStateException e) {
	             System.out.println("세션이 이미 무효화되었습니다.");
	         }
	         response.getWriter().write("{\"result\":\"success\"}");
	     } else {
	         response.getWriter().write("{\"result\":\"fail\"}");
	     }
	 }
}
