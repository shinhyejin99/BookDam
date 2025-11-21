package kr.or.ddit.dam.qna.controller;

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
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.vo.QnaAnswerVO;
import kr.or.ddit.dam.vo.QnaVO;

/**
 * Servlet implementation class QnaDetail
 */
@WebServlet("/QnaDetail.do")
public class QnaDetail extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private IQnaAnswerService answerService = QnaAnswerServiceImpl.getService();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaDetail() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 로그인 사용자 확인
		MemVO loginUser = (MemVO) request.getSession().getAttribute("loginOk");

		if (loginUser == null) {
		    response.sendRedirect(request.getContextPath() + "/log/login.jsp");
		    return;
		}
		String loginCustId = loginUser.getMem_mail(); // 로그인한 사용자 이메일
		
		// 1. 파라미터 추출
		String strQid = request.getParameter("qnaQid");
		//(String -> int)로 해야지 원글을 가져올수있음
		int qnaQid = Integer.parseInt(strQid);
		System.out.println("받은 qnaQid: " + qnaQid);
		
		//2. 원글 가져오기
		IQnaService service = QnaServiceImpl.getService();
		QnaVO qvo = service.getQnaByQid(qnaQid);
		System.out.println("QnaDetail->qvo : " + qvo);
		
		/*
		QnaVO [qnaQid=50, custId=testuser, qnaTitle=제발요, qnaContent=ㄴㄴㄴㄴㄴ, qnaDate=2025-06-24 19:17:32, qnaStatus=답변대기
		, qnaType=주문, qnaFileName=null, qnaFilePath=null, atchFileId=null
		, atchFileVO=null]
		 */
		
		// ❗ 작성자 검증 추가
		if (!loginCustId.equals(qvo.getCustId())) {
		    // 작성자가 아니면 403 에러
		    response.sendError(HttpServletResponse.SC_FORBIDDEN, "본인의 글만 열람할 수 있습니다.");
		    return;
		}
		
		//원글이랑 같이 qnaQid로 답변데이터 가져오기
		QnaAnswerVO answer = answerService.selectAnswerByQid(qnaQid); 
		
		//3.원글데이터, 답변데이터 저장
		request.setAttribute("qna", qvo);
		request.setAttribute("answer", answer);
		
		//view로 이동
		request.getRequestDispatcher("/qna/qnaDetail.jsp").forward(request, response);
	}
}
