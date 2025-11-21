package kr.or.ddit.dam.admin;

import java.io.IOException;
import java.util.Collection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.AtchFileServiceImpl;
import kr.or.ddit.dam.qna.service.IAtchFileService;
import kr.or.ddit.dam.qna.service.IQnaAnswerService;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaAnswerServiceImpl;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;
import kr.or.ddit.dam.util.MailUtil;
import kr.or.ddit.dam.vo.AtchFileVO;
import kr.or.ddit.dam.vo.QnaAnswerVO;
import kr.or.ddit.dam.vo.QnaVO;

/**
 * Servlet implementation class QnaAnswer
 */
@MultipartConfig
@WebServlet("/admin/QnaAnswerWrite.do")
public class QnaAnswerWrite extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	//서비스 객체
	private IQnaAnswerService answerService = QnaAnswerServiceImpl.getService();
	private IQnaService qnaService = QnaServiceImpl.getService();
	
	private IAtchFileService atchFileService = AtchFileServiceImpl.getInstance();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaAnswerWrite() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
    //답변저장
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("진입!!");
		
		Collection<jakarta.servlet.http.Part> parts = request.getParts();

	    String strQnaQid = request.getParameter("qnaQid");
	    if (strQnaQid == null || strQnaQid.isBlank()) {
	        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "qnaQid가 전달되지 않았습니다.");
	        return;
	    }
		//요청 파라미터값 받기
		int qnaQid = Integer.parseInt(request.getParameter("qnaQid"));
		QnaVO qvo = qnaService.getQnaByQid(qnaQid);
		System.out.println("받은 qnaQid = " + request.getParameter("qnaQid"));
		String qnaContent = request.getParameter("qnaContent");
		
	    // ✅ 첨부파일 업로드
	    //Collection<jakarta.servlet.http.Part> parts = request.getParts();
	    AtchFileVO fileVO = atchFileService.saveAtchFileList(parts, qnaQid, request);
	    System.out.println("첨부파일 업로드 처리 완료: " + fileVO);
		
		//답변VO
		QnaAnswerVO answer = new QnaAnswerVO();
		answer.setQnaQid(qnaQid);
		answer.setQnaContent(qnaContent);
		
		//답변저장
		int result = answerService.insertAnswer(answer);
		System.out.println("insertAnswer 결과: " + result);
		
		//답변저장성공시 상태변경
		if(result > 0) {
			//성공시
			qnaService.updateQnaStatus(qnaQid, "답변완료");
			
			//이메일 발송 로직 추가
			QnaVO qna = qnaService.getQnaWithEmailByQid(qnaQid);
			String to = qna.getMemMail();
			System.out.println("메일 주소 확인: " + qna.getMemMail());
			String subject = "[BOOKDAM]문의하신 내용에 대한 답변이 등록되었습니다.";
			String content = "문의하신 제목:" + qna.getQnaTitle() + "\n\n" + "관리자의 답변이 등록되었습니다. 사이트에 로그인하여 확인해주세요.\n\n감사합니다.";
			
			try {
				MailUtil.sendMail(to, subject, content);
				System.out.println("이메일 전송 성공");
			} catch (Exception e) {
				System.out.println("이메일 전송 실패 : " + e.getMessage());
				e.printStackTrace();
			}
			
			//답변목록으로 이동 
			response.sendRedirect(request.getContextPath() + "/admin/QnaAdminList.do");
		}else {
			//실패시
			request.setAttribute("error", "답변저장 실패");
			request.getRequestDispatcher("/admin/qna/qnaAnswerWrite.jsp?qnaQid=" + qnaQid).forward(request, response);
		}
		
	}

	//qna 답변 작성페이지로 이동
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//doPost(request, response);
		//int qnaQid = Integer.parseInt(request.getParameter("qnaQid"));
		//QnaVO qna = qnaService.getQnaByQid(qnaQid);
		//request.setAttribute("qna", qna);
		//request.getRequestDispatcher("/admin/qna/qnaAnswerWrite.jsp").forward(request, response);
        String strQnaQid = request.getParameter("qnaQid");
        System.out.println(">>> qnaQid parameter = " + strQnaQid);
        // 1. 파라미터 체크
        if (strQnaQid == null || strQnaQid.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "qnaQid가 누락되었습니다.");
            return;
        }

        try {
            // 2. 원글 로드
            int qnaQid = Integer.parseInt(strQnaQid);
            QnaVO qna = qnaService.getQnaByQid(qnaQid);

            if (qna == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "해당 QNA를 찾을 수 없습니다.");
                return;
            }
            // 👇 첨부파일 로드 부분
            AtchFileVO atchFile = atchFileService.getAtchFileByQnaQid(qnaQid);
            qna.setAtchFileVO(atchFile);
            
            System.out.println("첨부파일 VO: " + atchFile);
            if (atchFile != null && atchFile.getAtchFileDetailList() != null) {
                System.out.println("첨부파일 리스트 크기: " + atchFile.getAtchFileDetailList().size());
            } else {
                System.out.println("첨부파일 정보가 없습니다.");
            }
            
            // 3. 원글 데이터를 JSP로 전달
            request.setAttribute("qna", qna);
            request.getRequestDispatcher("/admin/qna/qnaAnswerWrite.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "qnaQid 형식이 잘못되었습니다.");
        }
	
		
	}
	
}
