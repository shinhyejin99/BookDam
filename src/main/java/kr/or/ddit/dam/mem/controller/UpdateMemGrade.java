package kr.or.ddit.dam.mem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.pay.service.IPayService;
import kr.or.ddit.dam.pay.service.PayServiceImpl;
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.vo.OrdersVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet implementation class UpdateMemGrade
 */
@WebServlet("/UpdateMemGrade.do")
public class UpdateMemGrade extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateMemGrade() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 회원 전체 정보 가져오기
		IMemService memService = MemServiceImpl.getService();
		List<MemVO> mvoList = memService.getAllMember();
		
		IOrderDao orderDao = OrderDaoImpl.getInstance();
		IPayService payService = PayServiceImpl.getInstance();
		
		int cnt = 0;
		for(MemVO mvo : mvoList) {
			int monthlyTotal = 0;
			// 회원의 한 달 구매 금액 가져오기
			int monthlyBuy = memService.getMemMonthlyBuy(mvo.getMem_mail());
			// 회원의 모든 주문번호 가져오기
			List<OrdersVO> odvList = orderDao.getOrdersMonthlyList(mvo.getMem_mail());
			
			// 주문번호가 환불 테이블에 있는지 확인하기
			for(OrdersVO odv : odvList) {
				int refundCnt = payService.getCheckRefund(odv);
				
				// 환불 테이블에 없다면 한달총구매금액에 더하기
				if (refundCnt == 0) {
					monthlyTotal += monthlyBuy;
				}
			}
			
			Map<String, Object> memMap = new HashMap<String, Object>();
			memMap.put("mem_mail", mvo.getMem_mail());
			memMap.put("monthlyTotal", monthlyTotal);
			
			cnt += memService.updateMemGrade(memMap);
			
			System.out.println("회원: " + mvo.getMem_mail() + " 한 달 구매금액: " + monthlyTotal);
		}
		
		if (cnt == mvoList.size()) {
			request.setAttribute("cnt", cnt);
			request.getRequestDispatcher("/cartDetailView/result.jsp").forward(request, response);
		}
	}
}
