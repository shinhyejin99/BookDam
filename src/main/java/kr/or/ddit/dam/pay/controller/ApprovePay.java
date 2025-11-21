package kr.or.ddit.dam.pay.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.vo.PaymentVO;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import com.google.gson.Gson;

/**
 * Servlet implementation class PayApprove
 */
@WebServlet("/ApprovePay.do")
public class ApprovePay extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApprovePay() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String token = "DEVA62A80D9697105B2E2D3FE9C72EDB9F6812F2";
		
		HttpSession session = request.getSession();
		String tid = (String) session.getAttribute("tid");
		String partner_order_id = (String) session.getAttribute("partner_order_id");
		String partner_user_id = (String) session.getAttribute("partner_user_id");
		String total_amount = (String) session.getAttribute("total_amount");		
		String use_mileage = (String) session.getAttribute("use_mileage");
		
		// KakaoPay api 요청
		URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/approve");
		// HttpURLConnection 객체 생성
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestProperty("Authorization", "SECRET_KEY " + token);
		conn.setRequestProperty("Content-Type", "application/json");
		conn.setDoOutput(true);
		
		/////////////////// Request Header 설정 완료 ///////////////////

		
		String jsonBody = "{"
		    + "\"cid\":\"TC0ONETIME\","
		    + "\"tid\":\""  +  tid  + "\","
		    + "\"partner_order_id\":\"" + partner_order_id + "\","
		    + "\"partner_user_id\":\"" + partner_user_id + "\","
		    + "\"pg_token\":\"" + request.getParameter("pg_token") + "\","
		    
		    ///////////////// 여기 !! 결제 승인되면 어디로..
			+ "\"approval_url\":\"http://localhost:8080/BookDam/PaySuccess.do\"," 
		    +"\"cancel_url\":\"http://localhost:8080\"," 
			+"\"fail_url\":\"http://localhost:8080\""
		    + "}";
		
		System.out.println("승인 요청 JSON: " + jsonBody);
		
		// 카카오페이 api로 결제 승인 전송
		try(OutputStream os = conn.getOutputStream()) {
			byte[] input = jsonBody.getBytes("utf-8");
			os.write(input, 0, input.length);
		}

		// 응답 코드 확인 200번이면 성공
		int code = conn.getResponseCode();
		System.out.println("승인 응답 코드 : " + code);
		
		////////////////// API로부터 응답 받음 ///////////////////
		// 에러 확인용 코드
		InputStream errorStream = conn.getErrorStream();
		if (errorStream != null) {
		    try (BufferedReader br1 = new BufferedReader(new InputStreamReader(errorStream, StandardCharsets.UTF_8))) {
		        StringBuilder response1 = new StringBuilder();
		        String line1;
		        while ((line1 = br1.readLine()) != null) {
		            response1.append(line1);
		        }
		        System.out.println("에러 메시지: " + response1.toString());
		    }
		}
		
		// 결제 승인까지 받으면
		if (code == 200) {
			// 결제 정보, 주문 번호 DB에 저장
			PaymentVO pvo = new PaymentVO();
			pvo.setPayment_no(Long.parseLong(partner_order_id));
			pvo.setPayment_amt(Integer.parseInt(total_amount));
			pvo.setUse_mileage(Integer.parseInt(use_mileage));
			pvo.setCust_id(partner_user_id);
			pvo.setTid(tid);
			IOrderDao orderDao = OrderDaoImpl.getInstance();
			orderDao.insertPayment(pvo);
			
			// response.sendRedirect("order/pay_result_page.jsp");
			
			// 서버 내부에서 전달하는 것이고, 그러므로 HTTP 메서드는 변하지 않음
			// 즉 만약 이 서블릿에서의 요청이 get이라면 paySuccess.do 도 get 요청으로 전달됨 (gpt..)
			request.getRequestDispatcher("/PaySuccess.do").forward(request, response);
		}
	}
}
