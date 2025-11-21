package kr.or.ddit.dam.qna.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;

import java.io.IOException;

/**
 * Servlet implementation class QnaDelete
 */
@WebServlet("/QnaDelete.do")
public class QnaDelete extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaDelete() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 String qnaQidStr = request.getParameter("qnaQid");
		    if (qnaQidStr == null || qnaQidStr.trim().isEmpty()) {
		        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "QNA번호 누락");
		        return;
		    }
		    
		    //삭제할 qnaQid추출
		    int qnaQid = Integer.parseInt(qnaQidStr);
		    
		    
		    //service객체 얻기
		    IQnaService service = QnaServiceImpl.getService();
		    //service메소드 호출
		    int res = service.deleteQna(qnaQid);

		    if (res > 0) {
		        //삭제 성공 후 즉시 종료
		        response.sendRedirect(request.getContextPath() + "/QnaList.do");
		        return;
		    } else {
		        request.setAttribute("error", "삭제 실패, 다시 시도해주세요.");
		        request.getRequestDispatcher("/qnaDetail.jsp?num=" + qnaQid).forward(request, response);
		        return;
		    }
	}
}
