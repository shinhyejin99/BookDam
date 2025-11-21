package kr.or.ddit.dam.orderManage.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.orderManage.service.IOrderManageService;
import kr.or.ddit.dam.orderManage.service.OrderManageServiceImpl;
import kr.or.ddit.dam.vo.OrderManageVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class OrderManageController
 */
@WebServlet("/orderManage.do")
public class OrderManageController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private IOrderManageService service = OrderManageServiceImpl.getService();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public OrderManageController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 관리자 주문 목록 화면 열기
		request.getRequestDispatcher("/orderManage/orderManage.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");
		response.setContentType("application/json; charset=utf-8");
		
		// 검색 파라미터 받기
        String searchType = request.getParameter("searchType");
        String searchWord = request.getParameter("searchWord");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String bookTitle = request.getParameter("bookTitle");
        String orderStatus = request.getParameter("orderStatus");
        String paymentStatus = request.getParameter("paymentStatus");
        int page = Integer.parseInt(request.getParameter("page"));
        int perPage = Integer.parseInt(request.getParameter("perPage"));

        int start = (page - 1) * perPage + 1;
        int end = start + perPage - 1;

        Map<String, Object> map = new HashMap<>();
        map.put("searchType", searchType);
        map.put("searchWord", searchWord);
        map.put("startDate", startDate);
        map.put("endDate", endDate);
        map.put("bookTitle", bookTitle);
        map.put("orderStatus", orderStatus);
        map.put("paymentStatus", paymentStatus);
        map.put("start", start);
        map.put("end", end);

        List<OrderManageVO> orderList = service.getOrderList(map);
        int totalCount = service.getOrderCount(map);

        Map<String, Object> result = new HashMap<>();
        result.put("orderList", orderList);
        result.put("totalCount", totalCount);

        String jsonData = new Gson().toJson(result);
        response.getWriter().write(jsonData);
	}
}
