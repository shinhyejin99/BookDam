package kr.or.ddit.dam.cart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.vo.CartDetailVO;

import java.io.IOException;

import com.google.gson.Gson;

/**
 * Servlet implementation class UpdateCartQty
 */
@WebServlet("/UpdateCartQty.do")
public class UpdateCartQty extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UpdateCartQty() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String btn = request.getParameter("btn");
		long book_no = Long.parseLong(request.getParameter("book_no"));
		String cust_id = request.getParameter("cust_id");
		
		ICartDao cartDao = CartDaoImpl.getInstance();
		
		CartDetailVO dvo = new CartDetailVO();
		dvo.setCust_id(cust_id);
		dvo.setBook_no(book_no);
		
		int cnt = cartDao.updateCartQty(btn, dvo);
		
		request.setAttribute("cnt", cnt);
		request.getRequestDispatcher("/cartDetailView/result.jsp").forward(request, response);;

		
	}

}
