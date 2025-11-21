package kr.or.ddit.dam.qna.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.vo.QnaVO;

/**
 * Servlet implementation class QnaList
 */
@WebServlet("/QnaList.do")
public class QnaList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
	    // 로그인 확인
	    MemVO loginUser = (MemVO) request.getSession().getAttribute("loginOk");

	    if (loginUser == null) {
	        // 로그인 안 했으면 로그인 페이지로 이동
	        response.sendRedirect(request.getContextPath() + "/log/login.jsp");
	        return;
	    }
		
	    // 로그인한 사용자의 이메일을 가져와서 본인 글만 조회
	    String custId = loginUser.getMem_mail();
	    
		IQnaService service = QnaServiceImpl.getService();
		
		//List<QnaVO> list = service.getAllQna();
		//request.setAttribute("qnaList", list);
		
        List<QnaVO> list = service.getMyQnaList(custId); //본인 글만 나오도록
        request.setAttribute("qnaList", list);
        System.out.println("QnaList 조회 요청자: " + custId);
		request.getRequestDispatcher("/qna/qnaList.jsp").forward(request, response);
		
	}

}
