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
import kr.or.ddit.dam.vo.MemVO;

import java.io.IOException;

/**
 * Servlet implementation class UpdateProfile
 */
@WebServlet("/UpdateProfile.do")

public class UpdateProfile extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateProfile() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    
		request.setCharacterEncoding("UTF-8");
		response.setContentType("application/json; charset=UTF-8");

		
		    HttpSession session = request.getSession(false);
		    
		    System.out.println("session id: " + (session != null ? session.getId() : "null"));
		    if(session != null) {
		        System.out.println("loginOk in session: " + session.getAttribute("loginOk"));
		        System.out.println("loginCust in session: " + session.getAttribute("loginCust"));
		    } else {
		        System.out.println("session is null");
		    }
		    
		    if (session == null) {
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
				return;
			}
		    
		 // 세션에서 MemVO와 CustVO 둘 다 꺼내기
	        MemVO loginMem = (MemVO) session.getAttribute("loginOk");
	        CustVO loginCust = (CustVO) session.getAttribute("loginCust");


	        if (loginMem == null || loginCust == null) {
	            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
	            return;
	        }
			
		    
	    
		
		// 멤버정보
		String pass = request.getParameter("mem_pass");
		String nickname = request. getParameter("mem_nickname");
		
		// 고객정보
		String name = request.getParameter("cust_name");
		String tel = request.getParameter("cust_tel");
		String zip = request.getParameter("cust_zip");
		String addr1 = request.getParameter("cust_addr1");
		String addr2 = request.getParameter("cust_addr2");
		
		String mem_mail = loginCust.getCust_id();
		
		//memvo세팅
		MemVO mvo = new MemVO();
		mvo.setMem_mail(mem_mail);
		mvo.setMem_pass(pass);
		mvo.setMem_nickname(nickname);
		
		//custvo세팅		
		CustVO cvo = new CustVO();
		cvo.setCust_id(mem_mail);
		cvo.setCust_name(name);
		cvo.setCust_tel(tel);
		cvo.setCust_zip(zip);
		cvo.setCust_addr1(addr1);
		cvo.setCust_addr2(addr2);
		
		//서비스 가져오기
		IMemService memservice = MemServiceImpl.getService();
		ICustService custservice = CustServiceImpl.getService();
		
		int res = memservice.updateMember(mvo);
		int res1 = custservice.updateCust(cvo);
		
	
		if (res > 0 && res1 > 0) {
	        response.getWriter().write("{\"result\": \"success\"}");
	    } else {
	        response.getWriter().write("{\"result\": \"fail\"}");
	    }
	}
		
}		
		
		
		
		
		