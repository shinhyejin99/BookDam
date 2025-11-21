package kr.or.ddit.dam.log.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class Logout
 */
@WebServlet("/Logout.do")
public class Logout extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Logout() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("application/json;charset=UTF-8");
		//session 객체를 생성
		HttpSession session = request.getSession(false);	
		
		Map<String, String> resultMap = new HashMap<String, String>();
		
		//session 값 비교
		if(session != null) {  //로그인 되엉 있는 상태
		session.invalidate(); //세션 삭제
		
		resultMap.put("flag", "ok");
		resultMap.put("message", "로그아웃되었습니다");
		
		System.out.println("세션이 무효화 되었습니다");
		
		}else { 
			
			resultMap.put("flag", "fail");
			resultMap.put("message", "이미 로그아웃 상태입니다");
			
			System.out.println(" 무효화 세션이 없습니다");
		}
		
		Gson gson = new Gson();
		response.getWriter().write(gson.toJson(resultMap));
		
		
	}

}
