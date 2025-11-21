package kr.or.ddit.dam.cart.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.util.StreamData;
import kr.or.ddit.dam.vo.CartItemVO;
import kr.or.ddit.dam.vo.DelCartVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.google.gson.Gson;

/**
 * Servlet implementation class DeleteCartItem
 */
@WebServlet("/DeleteCartItem.do")
public class DeleteCartItem extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DeleteCartItem() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		/*
		 * JSON 읽기 BufferedReader reader = request.getReader(); StringBuilder sb = new
		 * StringBuilder(); String line; while ((line = reader.readLine()) != null) {
		 * sb.append(line); }
		 * 
		 * String jsonData = sb.toString();
		 */
		String req = StreamData.getChange(request);

		// 역직렬화
		Gson gson = new Gson();
		DelCartVO delCart = gson.fromJson(req, DelCartVO.class);

		ICartDao cartDao = CartDaoImpl.getInstance();
		
		int cnt = cartDao.delCart(delCart);
		
		request.setAttribute("cnt", cnt);
		request.getRequestDispatcher("/cartDetailView/result.jsp").forward(request, response);
	}


}
