package kr.or.ddit.dam.order.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.vo.OrdersVO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class GetOrdersNo
 */
@WebServlet("/GetOrdersNo.do")
public class GetOrdersNo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetOrdersNo() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cust_id = request.getParameter("cust_id");
		
		System.out.println("getOrderNo.do 실행");
		
		IOrderDao orderDao = OrderDaoImpl.getInstance();
		List<OrdersVO> orderList = orderDao.getOrdersList(cust_id);
		
		request.setAttribute("orderList", orderList);
		request.getRequestDispatcher("/orderView/orderList.jsp").forward(request, response);
	}

}
