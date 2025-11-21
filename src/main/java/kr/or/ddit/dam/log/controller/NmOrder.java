package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.nomem.service.INomemService;
import kr.or.ddit.dam.nomem.service.NomemServiceImple;
import kr.or.ddit.dam.vo.NoMemVO;
import kr.or.ddit.dam.util.StreamData;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Servlet implementation class NmOrder
 */
@WebServlet("/NmOrder.do")
public class NmOrder extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NmOrder() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String reqData = StreamData.getChange(request);
		
		Gson gson = new Gson();
		
		
		NoMemVO nmvo = gson.fromJson(reqData, NoMemVO.class);
		
		INomemService noservice = NomemServiceImple.getNoService();
		
		List<NoMemVO> nvo = noservice.NoMemberOrder(nmvo);
		
		
		response.setContentType("application/json;charset=utf-8");
		
		PrintWriter out = response.getWriter();
		JsonObject json = new JsonObject();

		if (nvo != null) {
			// 로그인 성공
			json.addProperty("flag", "ok");
			json.addProperty("nmem_mail", nmvo.getNmem_mail());
			
			// 수현) 세션에 로그인 성공 회원 정보 저장!!!!- 추가
			request.getSession().setAttribute("nmloginOk", nvo.get(0));
			
		} else {
			// 로그인 실패
			json.addProperty("flag", "fail");
		}

		out.print(json.toString());
		out.flush();
	


	}

}
