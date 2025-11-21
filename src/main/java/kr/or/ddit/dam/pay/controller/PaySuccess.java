package kr.or.ddit.dam.pay.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.nomem.service.INomemService;
import kr.or.ddit.dam.nomem.service.NomemServiceImple;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.pay.service.IPayService;
import kr.or.ddit.dam.pay.service.PayServiceImpl;
import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.NoMemVO;
import kr.or.ddit.dam.vo.OrdersDetailVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;

/**
 * Servlet implementation class PaySuccess
 */
@WebServlet("/PaySuccess.do")
public class PaySuccess extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public PaySuccess() {
        super();
        // TODO Auto-generated constructor stub
    }


	// 리다이렉트를 쓰는 순간 doGet()으로만 이동이 가능. 
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	doPost(req, resp);
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("PaySuccess.do 실행");
		// 후처리는 보안을 위해 POST 방식을 선택함
		HttpSession session = request.getSession();

		// 세션에서 필요한 값들 가져옴
		Long partner_order_id = Long.parseLong((String) session.getAttribute("partner_order_id"));
		String partner_user_id = (String) session.getAttribute("partner_user_id");
		String use_mileage = (String) session.getAttribute("use_mileage");
		String form_data = (String) session.getAttribute("form_data");
		String sendArr = (String) session.getAttribute("sendArr");
		String giftArr = (String) session.getAttribute("giftArr");
		
		System.out.println("sendArr " + sendArr);
		System.out.println("giftArr " + giftArr);

        // form 데이터 Json 파싱 필요
		Gson gson = new Gson();		
		// String 형태의 JSON을 JSONObject 객체로.
		// 만약 String JSON 객체 배열이라면 JSONArray 객체로.
		JsonObject Jform = gson.fromJson(form_data, JsonObject.class);
		JsonArray JsendArr = gson.fromJson(sendArr, JsonArray.class);
		JsonArray JgiftArr = null;
		if (giftArr == null || giftArr.equals("null")) {
			JgiftArr = null;
		} else {
			System.out.println("변환 실행");
			JgiftArr = gson.fromJson(giftArr, JsonArray.class);			
		}
		
		// 비회원 비밀번호 값이 있는지 확인
		String nmem_pass = Jform.get("nmem_pass") != null && !Jform.get("nmem_pass").isJsonNull()? Jform.get("nmem_pass").getAsString() : null;
		
		System.out.println(Jform);
		System.out.println(JsendArr);
		System.out.println(JgiftArr);

			
		//////////////////////// 결제 후처리 ////////////////////////
		IPayService payService = PayServiceImpl.getInstance();
        // 주문번호(ok), 회원아이디(ok), {구매한도서번호, 수량, 도서가격, 적립마일리지(등급)}, 사용마일리지(ok), 사은품번호, 우편번호, 주소, 수령인, 전번, 비밀번호(비회원) 필요

		int earnRate = 0;
		// 0. 회원 등급 가져오기
		if (nmem_pass == null) {
			String memGrade = payService.getMemGrade(partner_user_id);
			if (memGrade.equals("일반등급") || memGrade.equals("일반 등급") || memGrade.equals("일반")) {
				earnRate = 5;
			} else if (memGrade.equals("실버")) {
				earnRate = 7;
			} else if (memGrade.equals("골드")) {
				earnRate = 8;
			} else if (memGrade.equals("다이아몬드")) {
				earnRate = 10;
			} 
			
			System.out.println("회원등급: " + memGrade);
		}
		
		
		SqlSession sqlSession = MybatisUtil.getInstance();
		
		try {
			/////////////////////////////////////////////////////////
			// 1. order_detail 테이블에 주문번호에 따라 {구매한도서번호, 수량, 도서가격, 적립마일리지(등급)} insert
			// 도서 정보(가격)을 가져오기 위해 bookService 객체 호출
			IBookService bookService = BookServiceImpl.getInstance();
			int total_earned_mileage = 0;
			// 구매한 도서 한 권씩 꺼내오기
			for (int i = 0; i < JsendArr.size(); i++) {
				// JsendArr -> JsonElement -> JsonObject
				JsonElement JsendEl = JsendArr.get(i);
				Long book_no = JsendEl.getAsJsonObject().get("book_no").getAsLong();
				int cart_qty = JsendEl.getAsJsonObject().get("cart_qty").getAsInt();
				
				// 도서 정보(가격), 적립 예정 마일리지 계산
				BookVO book_info = bookService.getBookDetail(book_no);
				int book_price = book_info.getBook_price();
				int earned_mileage = (int)(book_price * (earnRate / 100.0));
				
				// OrderDetail 테이블에 insert 하기 위한 orderItem 객체 생성
				OrdersDetailVO orderItem = new OrdersDetailVO();
				orderItem.setOrder_no(partner_order_id);
				orderItem.setBook_no(book_no);
				orderItem.setOrder_qty(cart_qty);
				orderItem.setOrder_price(book_price);
				orderItem.setEarned_mileage(earned_mileage);
				
				System.out.println("적립 마일리지: " + earned_mileage * cart_qty);
				total_earned_mileage += earned_mileage;
				
				// OrderDetail 테이블에 insert
				int cnt1 = payService.insertOrderDetail(orderItem);
				if (cnt1 > 0) {
					System.out.println("ORDER_DETAIL 테이블 INSERT 완료. " + i);
				} else {
					System.out.println("ORDER_DETAIL 테이블 INSERT 실패. " + i);
				}	
			}

			
			// 1.1 주문한 도서 재고 차감
			IOrderDao orderDao = OrderDaoImpl.getInstance();
			List<OrdersDetailVO> odvoList = orderDao.getOrdersDetailList(partner_order_id);
			
			for (OrdersDetailVO odvo : odvoList) {
				System.out.println("재고 업데이트 전: " + odvo.getBook_no() + " " + odvo.getOrder_qty());
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("book_no", odvo.getBook_no());
				paramMap.put("order_qty", odvo.getOrder_qty());
				paramMap.put("type", 0);
				
				bookService.updateStock(sqlSession, paramMap);
			}
	        
			/////////////////////////////////////////////////////////
	        // 2. gift_check 테이블에 주문번호에 따라 {사은품번호} insert
			if (JgiftArr != null) {
				// 선택한 사은품 하나씩 꺼내오기
				for (int i = 0; i < JgiftArr.size(); i++) {
					// JsendArr -> JsonElement -> JsonObject
					JsonElement JgiftEl = JgiftArr.get(i);
					
					int gift_no = JgiftEl.getAsJsonObject().get("gift_no").getAsInt();
	
					// giftMap = [{"order_no" : 1234567890123} {"gift_no" : 3}]
					Map<String, Object> giftMap = new HashMap<String, Object>();
					giftMap.put("order_no", partner_order_id);
					giftMap.put("gift_no", gift_no);
					
					// GiftCheck 테이블에 insert
					int cnt2 = payService.insertGiftCheck(sqlSession, giftMap);		
					if (cnt2 > 0) {
						System.out.println("GIFT_CHECK 테이블 INSERT 완료. " + i);
					} else {
						System.out.println("GIFT_CHECK 테이블 INSERT 실패. " + i);
					}
				}
			} else {
				System.out.println("보고 : JgiftArr = null, 사은품 insert 실행 안 함");
			}
			
			/////////////////////////////////////////////////////////
	        // 3. order_addr 테이블에 주문번호에 따라 우편번호, 기본주소, 상세주소, 이름, 전화번호 insert
			String cust_name = Jform.get("cust_name").getAsString();
			String cust_zip = Jform.get("cust_zip").getAsString();
			String cust_addr1 = Jform.get("cust_addr1").getAsString();
			
			String cust_addr2 = Jform.get("cust_addr2") != null && !Jform.get("cust_addr2").isJsonNull() ? Jform.get("cust_addr2").getAsString() : null;
			String cust_tel = Jform.get("cust_tel").getAsString();
			// String nmem_pass = Jform.get("nmem_pass") != null && !Jform.get("nmem_pass").isJsonNull()? Jform.get("nmem_pass").getAsString() : null;
			
			CustVO delivery_info = new CustVO(partner_user_id, cust_name, cust_zip, cust_addr1, cust_addr2, cust_tel, partner_order_id);	
			
			// Order_addr 테이블에 insert
			int cnt3 = payService.insertOrderAddr(sqlSession, delivery_info);
			
			if (cnt3 > 0) {
				System.out.println("ORDER_DETAIL 테이블 INSERT 완료.");
			} else {
				System.out.println("ORDER_DETAIL 테이블 INSERT 실패.");
			}
			
			/////////////////////////////////////////////////////////
	        // 4. 만약 orders 테이블의 nmem_check 가 N 이라면
			if (nmem_pass == null) {
				System.out.println("보고 : pass 값이 없으므로 회원");
				
				// 회원 전용 ***************************************************
				// 4-1. Member 테이블에 적립마일리지 update
		        // 4-2. Mileage 테이블에 회원아이디, 적립마일리지 insert
				Map<String, Object> mileageMap = new HashMap<String, Object>();
				mileageMap.put("mem_mail", partner_user_id);
				mileageMap.put("total_mileage", total_earned_mileage);
				mileageMap.put("mileage_type", "도서구매");
				
				// mileage 테이블에 적립 내역 insert, Member 테이블에 마일리지 update
				payService.insertMileage(sqlSession, mileageMap);
				
				// 회원 전용 ***************************************************
		        // 4-3. Member 테이블에 사용 마일리지 update
		        // 4-4. Mileage 테이블에 회원아이디, 사용마일리지 insert
				if (Integer.parseInt(use_mileage) != 0) {
					// 마일리지 update에 필요한 회원 아이디, 적립 또는 사용 마일리지
					mileageMap = new HashMap<String, Object>();
					mileageMap.put("mem_mail", partner_user_id);
					mileageMap.put("total_mileage", -(Integer.parseInt(use_mileage)));
					mileageMap.put("mileage_type", "결제사용");
					
					// mileage 테이블에 사용 내역 insert, Member 테이블에 마일리지 update
					payService.insertMileage(sqlSession, mileageMap);
				}
				
				
				// 회원 전용 ***************************************************
				// 4-4. cart_detail 테이블에서 회원아이디와 {구매한도서번호}에 따라 delete
				for (int i = 0; i < JsendArr.size(); i++) {
					// JsendArr -> JsonElement -> JsonObject
					JsonElement sendEl = JsendArr.get(i);
					
					Long book_no = sendEl.getAsJsonObject().get("book_no").getAsLong();
					
					// 삭제할 카트의 회원번호, 도서번호 Map
					Map<String, Object> cartMap = new HashMap<String, Object>();
					cartMap.put("cust_id", partner_user_id);
					cartMap.put("book_no", book_no);	
					
					// cart_detail 테이블 delete
					ICartDao cartDao = CartDaoImpl.getInstance();
					int CartCnt = cartDao.getCartBook(cartMap);
					// 만약 카트에 도서가 있다면
					if (CartCnt >= 1) {
						int cnt4 = cartDao.deleteCartDetail(sqlSession, cartMap);
						if (cnt4 > 0) {
							System.out.println("CART_DETAIL 테이블 DELETE 완료. " + i);
						} else {
							System.out.println("CART_DETAIL 테이블 DELETE 실패. (또는 바로 구매) " + i);
						}
					}
				}
				
			// 비회원 전용 ***************************************************
			} else {
				System.out.println("보고 : pass 값이 있으므로 비회원");
				
				NoMemVO vo = new NoMemVO(partner_user_id, Jform.get("nmem_pass").getAsString());
				
				// 5-1. no_member 테이블에 회원아이디, 회원비밀번호 insert
				INomemService nomemService = NomemServiceImple.getNoService();
				int cnt5 = nomemService.insertNoMember(sqlSession, vo);
				if (cnt5 > 0) {
					System.out.println("NOMEMBER 테이블 INSERT 완료.");
				} else {
					System.out.println("NOMEMBER 테이블 INSERT 실패.");
				}
		        // 5-2. cartArr 에서 세션값 삭제
				session.setAttribute("nmloginOk", vo);
			}
		
		sqlSession.commit();
		sqlSession.close();
		System.out.println("결제 후처리 커밋 완료.");
		
		response.sendRedirect("order/pay_result_page.jsp");
		
		} catch (Exception ex) {
			sqlSession.rollback();
			System.out.println("결제 후처리 오류. 롤백.");
			ex.printStackTrace();
			response.sendRedirect("order/pay_fail_page.jsp");
		} finally {
			sqlSession.close();
		}

		
        
	}

}
