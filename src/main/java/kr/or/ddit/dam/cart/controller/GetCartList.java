package kr.or.ddit.dam.cart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.vo.CartItemVO;

import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;

/**
 * Servlet implementation class UpdateCartInfo
 */
@WebServlet("/GetCartList.do")
public class GetCartList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetCartList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// get 으로 요청한 String 데이터 받기
		String cust_id = request.getParameter("cust_id");
		
		// dao 객체 얻어와서 cartList 결과 얻기
		ICartDao cartDao = CartDaoImpl.getInstance();
		List<CartItemVO> cartList = cartDao.getCartList(cust_id);
		
		// cartList 를 request 에 저장
		request.setAttribute("cartList", cartList);
		
		// view 로 이동
		request.getRequestDispatcher("/cartDetailView/cartList.jsp").forward(request, response);

	}

}
