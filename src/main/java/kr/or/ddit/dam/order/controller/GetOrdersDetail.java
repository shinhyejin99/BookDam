package kr.or.ddit.dam.order.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.vo.OrdersDetailVO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class GetOrdersDetail
 */
@WebServlet("/GetOrdersDetail.do")
public class GetOrdersDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetOrdersDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		long order_no = Long.parseLong(request.getParameter("order_no"));
		
		IOrderDao orderDao = OrderDaoImpl.getInstance(); 
		List<OrdersDetailVO> orderDetailList = orderDao.getOrdersDetailList(order_no);
		
		System.out.println("주문번호에 따른 주문내역 개수 " + orderDetailList.toString());
		request.setAttribute("orderDetailList", orderDetailList);
		request.getRequestDispatcher("/orderView/orderDetailList.jsp").forward(request, response);
	}

}
