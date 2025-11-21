package kr.or.ddit.dam.cart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.vo.CartDetailVO;
import kr.or.ddit.dam.vo.CartItemVO;

import java.io.IOException;

/**
 * Servlet implementation class InsertCartItem
 */
@WebServlet("/InsertCartItem.do")
public class InsertCartItem extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InsertCartItem() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cust_id = request.getParameter("cust_id");
		Long book_no = Long.parseLong(request.getParameter("book_no"));
		int cart_qty = Integer.parseInt(request.getParameter("cart_qty"));
		
		CartDetailVO cartItem = new CartDetailVO();
		cartItem.setCust_id(cust_id);
		cartItem.setBook_no(book_no);
		cartItem.setCart_qty(cart_qty);
		
		ICartDao cartDao = CartDaoImpl.getInstance();
		int cnt = cartDao.insertCart(cartItem);
		
		request.setAttribute("cnt", cnt);
		request.getRequestDispatcher("/cartDetailView/result.jsp").forward(request, response);
	}

}
