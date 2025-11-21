package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.vo.CustVO;


import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet implementation class mailFind
 */
@WebServlet("/mailFind.do")
public class mailFind extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public mailFind() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String name = request.getParameter("cust_name");
		String tel = request.getParameter("cust_tel");
		
		System.out.println("🔍 mailFind.do 요청 - name: [" + name + "], tel: [" + tel + "]");
		ICustService service = new CustServiceImpl();
		
		//db 메일찾기	
		String id = service.mailFind(name,tel);
		
		System.out.println("🔍 조회 결과 cvo: " + (id == null ? "null" : id));
		System.out.println("cust_name: " + name + ", cust_tel: " + tel);
		
		response.setContentType("application/json;charset=UTF-8");
		PrintWriter out = response.getWriter();
		
		if(id != null) {
		out.write("{\"id\":\"" + id + "\"}");
	}else {
			out.print("{}");
		}
			out.flush();
		
		}
	}

