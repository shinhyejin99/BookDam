package kr.or.ddit.dam.qna.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;
import kr.or.ddit.dam.vo.QnaVO;

/**
 * Servlet implementation class QnaEdit
 */
@WebServlet("/QnaEdit.do")
@MultipartConfig
public class QnaEdit extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaEdit() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//qnaQid추출
		int qnaQid = Integer.parseInt(request.getParameter("qnaQid"));
		
		//service객체 호출
		IQnaService service = QnaServiceImpl.getService();
		QnaVO qna = service.getQnaByQid(qnaQid);
		
		//view로 이동
		request.setAttribute("qna", qna);
		request.getRequestDispatcher("/qna/qnaEdit.jsp").forward(request, response);
		
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String strQid = request.getParameter("qnaQid");
		if(strQid == null || strQid.trim().isEmpty()) {
		    // qnaQid가 없으면 처리 중단 또는 기본값 처리
		    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "qnaQid is required");
		    return;
		}
		//int qnaQid = Integer.parseInt(strQid);
		
		
		//수정된 파라미터 추출(글번호, 제목, 유형, 내용)
		int qnaQid = Integer.parseInt(request.getParameter("qnaQid"));
		String title = request.getParameter("qnaTitle");
		String Type = request.getParameter("qnaType");
		String Content = request.getParameter("qnaContent");
		
		IQnaService service = QnaServiceImpl.getService();
		
		//기존 qnaStatus데이터 
		QnaVO existQna = service.getQnaByQid(qnaQid);
		
		//QnaVo 변경된 값 저장
		QnaVO qna = new QnaVO();
		qna.setQnaQid(qnaQid);
		qna.setQnaTitle(title);
		qna.setQnaType(Type);
		qna.setQnaContent(Content);
		
		//기존상태유지
		qna.setQnaStatus(existQna.getQnaStatus());
		qna.setCustId(existQna.getCustId());
		
		//service객체 호출
		int result = service.updateQna(qna);
		
		if(result > 0) {
			//성공시
			response.sendRedirect(request.getContextPath() + "/QnaList.do");
		}else {
			//실패시
			request.setAttribute("error", "수정실패");
			request.setAttribute("qna", qna);
			request.getRequestDispatcher("/qna/qnaEdit.jsp").forward(request, response);
		}
		
	}

	
}
