package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;


import java.io.IOException;

/**
 * Servlet implementation class DeleteMember
 */
@WebServlet("/AdminDeleteMember.do")
public class AdminDeleteMember extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminDeleteMember() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 System.out.println("AdminDeleteMember 서블릿 호출됨");

			
	        // 2. 관리자가 탈퇴할 회원 이메일 받기
	        String mem_mail = request.getParameter("mem_mail");  // 관리자 화면에서 보낸 이메일

	        if (mem_mail == null || mem_mail.trim().isEmpty()) {
	            response.setContentType("application/json; charset=UTF-8");
	            response.getWriter().write("{\"result\":\"fail\", \"message\":\"탈퇴할 회원 이메일이 없습니다.\"}");
	            return;
	        }

	        System.out.println("탈퇴 요청 회원 이메일 : " + mem_mail);

	        // 3. 회원 탈퇴 처리
	        IMemService memService = MemServiceImpl.getService();
	        int memres = memService.resignMember(mem_mail);

	        System.out.println("탈퇴 처리 결과(resignMember 반환값) : " + memres);

	        // 4. 응답 반환
	        response.setContentType("application/json; charset=UTF-8");
	        if (memres > 0) {
	            response.getWriter().write("{\"result\":\"success\"}");
	        } else {
	            response.getWriter().write("{\"result\":\"fail\", \"message\":\"회원 탈퇴 실패\"}");
	        }
	    }
	}