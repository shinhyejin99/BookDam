package kr.or.ddit.dam.pay.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.mem.dao.IMemDao;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.pay.service.IPayService;
import kr.or.ddit.dam.pay.service.PayServiceImpl;
import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.OrdersDetailVO;
import kr.or.ddit.dam.vo.PaymentVO;
import kr.or.ddit.dam.vo.RefundVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

/**
 * Servlet implementation class RefundSuccess
 */
@WebServlet("/RefundSuccess.do")
public class RefundSuccess extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RefundSuccess() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("RefundSuccess.do 실행");
		
		HttpSession session = request.getSession();
		
		Long order_no = (Long) session.getAttribute("order_no");
		String refund_reason = (String) session.getAttribute("refund_reason");
		
		SqlSession sqlSession = MybatisUtil.getInstance();
		
		try {
			
			// ** refund 테이블에 주문번호, 환불신청일, 결제한금액, 사용했던마일리지, 적립받았던마일리지, 환불사유 insert
			IPayService payService = PayServiceImpl.getInstance();
			
			// 결제한금액, 사용했던마일리지 얻어오기
			PaymentVO pvo = payService.getPaymentInfo(order_no);
			int payment_amt = pvo.getPayment_amt();
			int used_mile = pvo.getUse_mileage();
			
			// 적립받았던마일리지 계산
			List<Integer> earnedMileList = payService.getMileList(order_no);
			
			int totalEarnedMile = 0;
			for(int earnedMile : earnedMileList) {
				totalEarnedMile += earnedMile;
			}
			System.out.println("totalEarnedMile = " + totalEarnedMile);
			
			// refund 테이블에 insert
			RefundVO rvo = new RefundVO();
			rvo.setOrder_no(order_no);
			rvo.setRfd_amt(payment_amt);
			rvo.setRfd_use_mileage(used_mile);
			rvo.setRfd_earned_mileage(totalEarnedMile);
			rvo.setRfd_reason(refund_reason);
			
			int cnt1 = payService.insertRefund(sqlSession, rvo);
			if (cnt1 > 0) {
				System.out.println("REFUND 테이블 INSERT 완료.");
			} else {
				System.out.println("REFUND 테이블 INSERT 실패.");
				
			}
			
			
			// 회원 전용 ***************************************************
			
			// ** 회원 체크
			ICustService custService = CustServiceImpl.getService();
			int cnt2 = custService.checkCustIdExists(pvo.getCust_id());
			
			if (cnt2 > 0) {
				
				// ** member 테이블에 사용했던마일리지 증가, 적립받았던마일리지 차감 update
				Map<String, Object> memMap = new HashMap<String, Object>();
				memMap.put("mem_mail", pvo.getCust_id());
				memMap.put("used_mileage", used_mile);
				memMap.put("earned_mileage", -totalEarnedMile);
				
				IMemService memService = MemServiceImpl.getService();
				memService.updateMileage(sqlSession, memMap);
					
				// ** mileage 테이블에  '환불 적립 마일리지 차감', '환불 사용 마일리지 재적립' insert
				if (used_mile > 0) {
					memService.insertUsedMileageInfo(sqlSession, memMap);
				}
				
				if (totalEarnedMile > 0) {
					memService.insertEarnedMileageInfo(sqlSession, memMap);
				}
				
			}
			
			// ***********************************************************
			
			
			// ** book 테이블에서 재고 증가	
			// 주문한 도서 정보 전부 가져오기 (도서 번호, 수량)
			IOrderDao orderDao = OrderDaoImpl.getInstance();
			List<OrdersDetailVO> odvoList = orderDao.getOrdersDetailList(order_no);
			
			IBookService bookService = BookServiceImpl.getInstance();
			for (OrdersDetailVO odvo : odvoList) {
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("book_no", odvo.getBook_no());
				paramMap.put("order_qty", odvo.getOrder_qty());
				paramMap.put("type", 1);
				
				int cnt3 = bookService.updateStock(sqlSession, paramMap);
				if (cnt3 > 0) {
					System.out.println("STCOK_QTY 업데이트 완료.");
				} else {
					System.out.println("STCOK_QTY 업데이트 실패.");
				}
			}
			
			sqlSession.commit();
			sqlSession.close();
			System.out.println("환불 후처리 커밋 완료.");
			
			request.setAttribute("cnt", 1);
			request.getRequestDispatcher("/cartDetailView/result.jsp").forward(request, response);
			
		} catch (Exception ex) {
			sqlSession.rollback();
			System.out.println("환불 후처리 오류. 롤백.");
			ex.printStackTrace();
		} finally {
			sqlSession.close();
		}
		
	}

}
