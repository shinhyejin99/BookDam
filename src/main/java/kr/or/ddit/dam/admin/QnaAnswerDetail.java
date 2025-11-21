package kr.or.ddit.dam.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.IQnaAnswerService;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaAnswerServiceImpl;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;
import kr.or.ddit.dam.vo.QnaAnswerVO;
import kr.or.ddit.dam.vo.QnaVO;

/**
 * Servlet implementation class QnaAnswerDetail
 */
@WebServlet("/admin/QnaAnswerDetail.do")
public class QnaAnswerDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private IQnaAnswerService answerService = QnaAnswerServiceImpl.getService();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaAnswerDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//파라미터 추출
		String strQid = request.getParameter("qnaQid");
		int qnaQid = Integer.parseInt(strQid);
		
		IQnaService service = QnaServiceImpl.getService();
		QnaVO qvo = service.getQnaByQid(qnaQid); 
		
		QnaAnswerVO answer = answerService.selectAnswerByQid(qnaQid); 
		System.out.println("QnaDetail->answer : " + answer);
		
		request.setAttribute("qna", qvo);
		request.setAttribute("answer", answer);
		
		//view로 이동
		request.getRequestDispatcher("/admin/qna/qnaAnswerDetail.jsp").forward(request, response);
	}

}
