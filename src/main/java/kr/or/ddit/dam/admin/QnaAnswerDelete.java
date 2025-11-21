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

/**
 * Servlet implementation class QnaAnswerDelete
 */
@WebServlet("/admin/QnaAnswerDelete.do")
public class QnaAnswerDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private IQnaAnswerService answerService = QnaAnswerServiceImpl.getService();
	private IQnaService qnaService = QnaServiceImpl.getService();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaAnswerDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int qnaQid = Integer.parseInt(request.getParameter("qnaQid"));
		
		//문의글 삭제(관리자페이지)
        answerService.deleteAnswer(qnaQid);
		
        //문의글 삭제(사용자페이지)
		qnaService.deleteQna(qnaQid);
		
		//포워딩
		response.sendRedirect(request.getContextPath() + "/admin/QnaAdminList.do");
	}

}
