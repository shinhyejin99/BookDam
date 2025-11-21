package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

import java.io.IOException;

import org.apache.ibatis.session.SqlSession;

/**
 * Servlet implementation class IdCheck
 */
@WebServlet("/IdCheck.do")
public class IdCheck extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public IdCheck() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String memMail = request.getParameter("mem_mail");
		
	SqlSession sql = MybatisUtil.getInstance();
	
	MemVO  mv= sql.selectOne("member.getMemberById", memMail);
	
	request.setAttribute("result", mv);
			
	request.getRequestDispatcher("/log/IdCheck.jsp").forward(request, response);

		
	}
}
