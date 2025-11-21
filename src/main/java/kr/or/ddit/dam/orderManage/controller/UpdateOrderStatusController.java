package kr.or.ddit.dam.orderManage.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.orderManage.service.IOrderManageService;
import kr.or.ddit.dam.orderManage.service.OrderManageServiceImpl;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class UpdateOrderStatusController
 */
@WebServlet("/updateOrderStatus.do")
public class UpdateOrderStatusController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IOrderManageService service = OrderManageServiceImpl.getService();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateOrderStatusController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
	    response.setContentType("application/json; charset=utf-8");
	    
	    String orderNo = request.getParameter("orderNo");
	    String orderStatus = request.getParameter("orderStatus");

	    Map<String, Object> map = new HashMap<>();
	    map.put("orderNo", orderNo);
	    map.put("orderStatus", orderStatus);

	    // boolean isRefunded = service.checkRefundExists(orderNo);
	    Map<String, Object> result = new HashMap<>();

	    // 환불 체크 및 관련 로직 제외하고 단순 상태 변경만 처리(가영이와 상의후)
	    int cnt = service.changeOrderStatus(map);
	 // 🔽 취소/반품 완료된 경우 수정 불가
		/*
		 * if (isRefunded && !"취소/반품 완료".equals(orderStatus)) { result.put("success",
		 * false); result.put("message", "이미 취소/반품 완료된 주문은 상태 변경이 불가합니다."); } else {
		 * map.put("orderStatus", orderStatus); int cnt =
		 * service.changeOrderStatus(map);
		 * 
		 * // 🔽 상태가 '취소/반품 완료'일 경우, 환불 완료일자도 갱신 if ("취소/반품 완료".equals(orderStatus)) {
		 * service.updateRefundCompleteDate(orderNo); }
		 * */
		 result.put("success", cnt > 0);
		 result.put("message", cnt > 0 ? "주문 상태가 수정되었습니다." : "주문 상태 수정 실패");
		 
	    String json = new Gson().toJson(result);
	    response.getWriter().write(json);
	}
}
