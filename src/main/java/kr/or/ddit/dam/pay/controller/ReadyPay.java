package kr.or.ddit.dam.pay.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.vo.KakaoPayReadyResVO;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.apache.tomcat.util.json.JSONParser;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Servlet implementation class Pay
 */
@WebServlet("/ReadyPay.do")
public class ReadyPay extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public ReadyPay() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String token = "";
		
		// KakaoPay api 요청 
		URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/ready");
		// HttpURLConnection 객체 생성 (카카오 API 서버와 현재 서블릿 사이에 HTTP 통신 만들기)
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST"); // 요청 방식 선택
		conn.setRequestProperty("Authorization", "SECRET_KEY " + token);
		conn.setRequestProperty("Content-Type", "application/json");
		// conn.setDoInput(true);
		conn.setDoOutput(true); // OutputStream으로 POST 데이터를 넘겨주겠다는 옵션
		//conn.setRequestProperty("Access-Control-Allow-Orign", "*");
		
		/////////////////// Request Header 설정 완료 ///////////////////
		
		// 카트 번호를 얻어오는 dao 필요
		IOrderDao orderDao = OrderDaoImpl.getInstance();
		Long partner_order_id = orderDao.getOrderNo();
		System.out.println("주문 번호 : " + partner_order_id);
		
		// 카카오페이 api 에 전송할 데이터 생성
		String jsonBody = "{"
			    + "\"cid\":\"TC0ONETIME\","
			    + "\"partner_order_id\":\""  +  partner_order_id   + "\","
			    + "\"partner_user_id\":\"" + request.getParameter("partner_user_id") + "\","
			    + "\"item_name\":\"" + request.getParameter("name") + "\","
			    + "\"quantity\":" + request.getParameter("quantity") + ","
			    + "\"total_amount\":" + request.getParameter("total_amount") + ","
			    + "\"tax_free_amount\":" + request.getParameter("tax_free_amount") + ","
			    + "\"approval_url\":\"http://localhost:8080/BookDam/ApprovePay.do\","
			    + "\"cancel_url\":\"http://localhost:8080\","
			    + "\"fail_url\":\"http://localhost:8080\""
			    + "}";
		
		System.out.println(jsonBody);
		
		// 전송
		try(OutputStream os = conn.getOutputStream()) {
			byte[] input = jsonBody.getBytes("utf-8");
			os.write(input, 0, input.length);
		}

		// 응답 코드 확인 200번이면 성공
		int code = conn.getResponseCode();
		System.out.println("준비 응답 코드 : " + code);
		
		// 응답 받은 데이터 buffer로 읽기
		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
		StringBuilder responseText = new StringBuilder();
		String line;

		while ((line = br.readLine()) != null) {
		    responseText.append(line);
		}
		
		br.close();
		
		////////////////// API로부터 응답 받음 ///////////////////
		
		
		// String 형태의 JSON를 JAVA 객체로 변환
		String responseStr = responseText.toString();
		Gson gson = new Gson();
		KakaoPayReadyResVO readyResponse = gson.fromJson(responseStr, KakaoPayReadyResVO.class);
		
		
		// paySuccess.do 에서 사용할 값들 세션에 저장
		//Transaction ID의 약자로, 카카오페이가 이 결제 준비 요청(ready API 호출)에 대해 발급해주는 고유한 결제 식별 번호
		HttpSession session = request.getSession();
		session.setAttribute("tid", readyResponse.getTid());
		session.setAttribute("partner_order_id", String.valueOf(partner_order_id));
		session.setAttribute("partner_user_id", request.getParameter("partner_user_id"));
		session.setAttribute("total_amount", request.getParameter("total_amount"));	
		session.setAttribute("use_mileage", request.getParameter("use_mileage"));
		session.setAttribute("form_data", request.getParameter("form_data"));
		session.setAttribute("sendArr", request.getParameter("sendArr"));
		session.setAttribute("giftArr", request.getParameter("giftArr"));
		
		// view 페이지로 이동
		request.setAttribute("readyResponse", readyResponse);
		request.getRequestDispatcher("/payView/kakaoPayRes.jsp").forward(request, response);
		// 결제 페이지로 이동 (이건 불가능)
		// response.sendRedirect(readyResponse.getNext_redirect_pc_url());
				
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
	}
}
