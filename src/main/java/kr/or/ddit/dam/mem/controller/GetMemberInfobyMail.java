package kr.or.ddit.dam.mem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.vo.MemVO;

import java.io.IOException;

/**
 * Servlet implementation class GetMemberInfobyMail
 */
@WebServlet("/GetMemberInfobyMail.do")
public class GetMemberInfobyMail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetMemberInfobyMail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 이메일로 멤버 정보를 얻어오기 위한 서블릿
		String mem_mail = request.getParameter("mem_mail");
		
		IMemService memService = MemServiceImpl.getService();
		MemVO mvo =  memService.getMember(mem_mail);
		
		request.setAttribute("mvo", mvo);
		request.getRequestDispatcher("/memberView/member.jsp").forward(request, response);
		
	}

}
