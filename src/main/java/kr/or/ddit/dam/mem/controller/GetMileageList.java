package kr.or.ddit.dam.mem.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.vo.MileageVO;

import java.io.IOException;
import java.util.List;

/**
 * Servlet implementation class GetMileageList
 */
@WebServlet("/GetMileageList.do")
public class GetMileageList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetMileageList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String mem_mail = request.getParameter("mem_mail");
		
		IMemService memService = MemServiceImpl.getService();
		List<MileageVO> mileageList=  memService.getMileageList(mem_mail);
		
		request.setAttribute("mileageList", mileageList);
		request.getRequestDispatcher("/myPageView/mileageList.jsp").forward(request, response);
	}

}
