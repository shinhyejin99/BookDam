package kr.or.ddit.dam.cart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.vo.DeliveryVO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class GetDeliveryInfo
 */
@WebServlet("/GetDeliveryInfo.do")
public class GetDeliveryInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetDeliveryInfo() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cust_id = request.getParameter("cust_id");
		
		ICartDao cartDao = CartDaoImpl.getInstance();
		DeliveryVO deliveryInfo = cartDao.getDeliveryInfo(cust_id);
		
		request.setAttribute("deliveryInfo", deliveryInfo);
		
		request.getRequestDispatcher("/cartDetailView/deliveryInfo.jsp").forward(request, response);
		
	}

}
