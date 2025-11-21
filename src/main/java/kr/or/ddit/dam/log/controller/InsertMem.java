package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.pay.dao.IPayDao;
import kr.or.ddit.dam.pay.dao.PayDaoImpl;
import kr.or.ddit.dam.vo.MemVO;


import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet implementation class InsertMember
 */

@WebServlet("/InsertMember.do")
public class InsertMem extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InsertMem() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		String mail = request.getParameter("mem_mail");
		System.out.println("mem_mail: " + mail);
		
		if(mail == null || mail.trim().isEmpty()) {
	        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        response.getWriter().write("{\"error\": \"이메일이 입력되지 않았습니다.\"}");
	        return;
	    }
		
		String pass = request.getParameter("mem_pass");
		
		String birStr = request.getParameter("mem_bir");
		
		int bir = 0;
		if (birStr != null && !birStr.isEmpty()) {
		    birStr = birStr.replace("-", ""); // "2024-06-30" → "20240630"
		    try {
		        bir = Integer.parseInt(birStr); // "20240630" → 20240630
		    } catch (NumberFormatException e) {
		        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
		        response.getWriter().write("{\"error\": \"생년월일 형식이 잘못되었습니다.\"}");
		        return;
		    }
		}
		

		String gender = request.getParameter("mem_gender");
		if (gender == null || gender.trim().isEmpty()) {
		    gender = "U"; // 기본값, 예: 'U' = Unknown, 혹은 'M'/'F' 중 적당한 기본값
		}
		String nickname = request.getParameter("mem_nickname");
		
		String mileage = request.getParameter("mem_mileage");
		
		MemVO vo = new MemVO();
		vo.setMem_mail(mail);
		vo.setMem_pass(pass);
		vo.setMem_bir(bir);
		vo.setMem_gender(gender);
		vo.setMem_nickname(nickname);
		vo.setMem_mileage(0);
		Date utilDate = new Date();  // java.util.Date
		java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
		vo.setMem_join(sqlDate);
		
		if(vo.getMem_resign() == null) {
		    vo.setMem_resign("N");
		}
		
		
		IMemService service = MemServiceImpl.getService();
		
		int res = service.insertMember(vo);
		
		
		
		 response.setContentType("application/json;charset=UTF-8");
	        response.getWriter()
	            .write("{\"flag\":\"" + (res == 1 ? "회원 등록 성공" : "회원 등록 실패") + "\"}");
	    }
}