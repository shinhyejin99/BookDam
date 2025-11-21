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
 * Servlet implementation class NickCheck
 */
@WebServlet("/NickCheck.do")
public class NickCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NickCheck() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String nickname = request.getParameter("mem_nickname");
		 System.out.println("Controller nicknamecheck - 요청 닉네임: " + nickname);

		IMemService service = MemServiceImpl.getService();
		String resultNick = service.nicknamecheck(nickname);
		System.out.println("Controller nicknamecheck - 서비스 결과: " + resultNick);

		String resultMsg = (resultNick != null) ? "이미 사용중인 닉네임입니다." : "사용가능한 닉네임입니다.";

		response.setContentType("application/json;charset=UTF-8");
		response.getWriter().write("{\"flag\":\"" + resultMsg + "\"}");
	}
}