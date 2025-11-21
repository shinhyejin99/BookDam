package kr.or.ddit.dam.qna.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;
import kr.or.ddit.dam.vo.QnaStatusVO;

import java.io.IOException;

/**
 * Servlet implementation class QnaStatusCount
 */
@WebServlet("/QnaStatusCnt.do")
public class QnaStatusCnt extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaStatusCnt() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 마이페이지에서 필요 (가영)
		String cust_id = request.getParameter("cust_id");
		
		IQnaService qnaService = QnaServiceImpl.getService();
		QnaStatusVO qvo = qnaService.getQnaStatusCnt(cust_id);
		
		request.setAttribute("qvo", qvo);
		request.getRequestDispatcher("/qna/qnaStatusCntView.jsp").forward(request, response);
	}

}
