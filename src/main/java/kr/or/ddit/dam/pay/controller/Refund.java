package kr.or.ddit.dam.pay.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.pay.dao.IPayDao;
import kr.or.ddit.dam.pay.service.IPayService;
import kr.or.ddit.dam.pay.service.PayServiceImpl;
import kr.or.ddit.dam.util.StreamData;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import org.apache.tomcat.util.json.JSONParser;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

/**
 * Servlet implementation class Refund
 */
@WebServlet("/Refund.do")
public class Refund extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Refund() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String token = "";

		// KakaoPay api 요청
		URL url = new URL("https://open-api.kakaopay.com/online/v1/payment/cancel");
		// HttpURLConnection 객체 생성
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST"); // 요청 방식 선택
		conn.setRequestProperty("Authorization", "SECRET_KEY " + token);
		conn.setRequestProperty("Content-Type", "application/json");
		// conn.setDoInput(true);
		conn.setDoOutput(true); // OutputStream으로 POST 데이터를 넘겨주겠다는 옵션
		// conn.setRequestProperty("Access-Control-Allow-Orign", "*");

		String reqData = StreamData.getChange(request);

		System.out.println("reqData = " + reqData);

		// String 형태의 JSON을 JSONObject 객체로.
		Gson gson = new Gson();
		JsonObject JreqData = gson.fromJson(reqData, JsonObject.class);

		// JsonObject에서 필요한 값 꺼내기
		Long order_no = JreqData.get("order_no").getAsLong();
		int cancel_amount = JreqData.get("cancel_amount").getAsInt();
		int quantity = JreqData.get("quantity").getAsInt();
		int total_amount  = JreqData.get("total_amount").getAsInt();
		int tax_free_amount = JreqData.get("tax_free_amount").getAsInt();
		String refund_reason = JreqData.get("refund_reason").getAsString();


		// tid를 얻어오는 dao 필요
		IPayService payService = PayServiceImpl.getInstance();
		String tid = payService.getTid(order_no);
		System.out.println("가져온 tid : " + tid);

		// 카카오페이 api 에 전송할 데이터 생성

		  String jsonBody = "{"
		  + "\"cid\":\"TC0ONETIME\","
		  + "\"tid\":\"" + tid + "\","
		  + "\"cancel_amount\":" + cancel_amount + ","
		  + "\"cancel_tax_free_amount\":" + tax_free_amount + ""
	      + "}";

		  System.out.println(jsonBody);

		// 전송
		try(OutputStream os = conn.getOutputStream()) {
			byte[] input = jsonBody.getBytes("utf-8");
			os.write(input, 0, input.length);
		}

		// 응답 코드 확인 200번이면 성공
		int code = conn.getResponseCode();
		System.out.println("환불 응답 코드 : " + code);

		// 응답 받은 데이터 buffer로 읽기
		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
		StringBuilder responseText = new StringBuilder();
		String line;

		while ((line = br.readLine()) != null) {
		    responseText.append(line);
		}

		br.close();

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

		if (code == 200) {
			// 세션 세팅
			HttpSession session = request.getSession();
			session.setAttribute("order_no", order_no); // 주문 번호
			session.setAttribute("refund_reason", refund_reason); // 환불 사유

			request.getRequestDispatcher("/RefundSuccess.do").forward(request, response);
		}
	}

}
