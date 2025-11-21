package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet implementation class SendMail
 */
@WebServlet("/SendMail.do")
public class SendMail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SendMail() {
        super();
        // TODO Auto-generated constructor stub
    }

    static Map<String, String> authCodes = new HashMap<>();

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String mail = request.getParameter("mem_mail");
		
		String authCode = String.valueOf((int)(Math.random() * 900000) + 100000);
		authCodes.put(mail, authCode);
		
		response.setContentType("application/json; charset=UTF-8");
		PrintWriter out = response.getWriter();
		out.print("{ \"msg\": \"인증번호가 전송되었습니다.\" }");
		out.flush();
	
	
	}

}
