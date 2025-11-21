package kr.or.ddit.dam.order.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.order.dao.IOrderDao;
import kr.or.ddit.dam.order.dao.OrderDaoImpl;
import kr.or.ddit.dam.vo.GiftVO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class GetGiftInfo
 */
@WebServlet("/GetGiftInfo.do")
public class GetGiftInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetGiftInfo() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		IOrderDao orderDao = OrderDaoImpl.getInstance();
		List<GiftVO> giftList = orderDao.getGiftList();
		
		request.setAttribute("giftList", giftList);
		request.getRequestDispatcher("/orderView/giftList.jsp").forward(request, response);
		
	}

}
