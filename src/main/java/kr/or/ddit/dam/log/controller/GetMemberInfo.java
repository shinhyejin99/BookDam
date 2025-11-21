package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.MemVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class GetMemberInfo
 */
@WebServlet("/GetMemberInfo.do")
public class GetMemberInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	 private IMemService memService = MemServiceImpl.getService();
	    private ICustService custService = CustServiceImpl.getService();

	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetMemberInfo() {
        super();
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		
		// 한글 인코딩 및 JSON 설정
		 request.setCharacterEncoding("UTF-8");
	        response.setContentType("application/json; charset=UTF-8");

	        // 1. 로그인 없이 관리자 페이지 접근 가능
	        String paramMail = request.getParameter("mem_mail");
	        String mem_mail;

	        // 관리자는 모든 이메일 조회 가능, 일반 회원은 본인만 조회 가능
	        if (paramMail == null || paramMail.isEmpty()) {
	            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "이메일 파라미터가 필요합니다.");
	            return;
	        } else {
	            mem_mail = paramMail;
	        }

	        // 회원 정보 조회
	        MemVO mvo = memService.getMember(mem_mail);
	        CustVO cvo = custService.getCustId(mem_mail);

	        if (mvo == null || cvo == null) {
	            response.sendError(HttpServletResponse.SC_NOT_FOUND, "회원 정보가 존재하지 않습니다.");
	            return;
	        }

	        // JSON 데이터 구성
	        Map<String, Object> result = new HashMap<>();
	        result.put("mem_mail", mvo.getMem_mail());
	        result.put("mem_pass", mvo.getMem_pass());
	        result.put("mem_bir", mvo.getMem_bir());
	        result.put("mem_gender", mvo.getMem_gender());
	        result.put("mem_nickname", mvo.getMem_nickname());
	        result.put("cust_id", cvo.getCust_id());
	        result.put("cust_name", cvo.getCust_name());
	        result.put("cust_zip", cvo.getCust_zip());
	        result.put("cust_addr1", cvo.getCust_addr1());
	        result.put("cust_addr2", cvo.getCust_addr2());
	        result.put("cust_tel", cvo.getCust_tel());

	        // JSON 응답 전송
	        String jsonResponse = new Gson().toJson(result);
	        response.getWriter().write(jsonResponse);
	    }
	}