package kr.or.ddit.dam.qna.controller;

import java.io.IOException;
import java.util.Collection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import kr.or.ddit.dam.qna.service.AtchFileServiceImpl;
import kr.or.ddit.dam.qna.service.IAtchFileService;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;
import kr.or.ddit.dam.vo.AtchFileVO;
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.vo.QnaVO;

/**
 * Servlet implementation class QnaWrite
 */
@WebServlet("/QnaWrite.do")
@MultipartConfig
public class QnaWrite extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private IQnaService service = QnaServiceImpl.getService();
	private IAtchFileService atchFileService = AtchFileServiceImpl.getInstance();
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public QnaWrite() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("QnaWrite 서블릿 doPost 실행됨!");

        // 1. 파라미터 추출
        String title = request.getParameter("title");
        String qnaType = request.getParameter("qnaType");
        String content = request.getParameter("content");
        
        // null 체크 (예외 상황 방어 가능)
        if (title == null || title.trim().isEmpty()) {
            title = "제목 없음"; // 임시값 또는 예외처리
        }
        if (content == null || content.trim().isEmpty()) {
            content = "내용 없음"; // 같은 방식
        }
        
        // 2. VO 객체 생성
        QnaVO qvo = new QnaVO();
        qvo.setQnaTitle(title);
        qvo.setQnaContent(content);
        qvo.setQnaType(qnaType);
        qvo.setQnaQid(0);
        qvo.setQnaStatus("답변대기");  

        //세션에서 custId가져오기
		/*
		 * String custId = (String) request.getSession().getAttribute("custId"); // 로그인
		 * 구현이 안 되어 있으면 아래처럼 임시 값 if (custId == null) { custId = "testuser"; }
		 * qvo.setCustId(custId);
		 */

        MemVO loginUser = (MemVO) request.getSession().getAttribute("loginOk");

        if (loginUser == null) {
            // 로그인 안된 경우: 로그인 페이지로 보내기
            response.sendRedirect(request.getContextPath() + "/log/login.jsp");
            return;
        }

        // 로그인된 사용자라면 이메일(mem_mail)을 custId로 사용
        String custId = loginUser.getMem_mail();
        qvo.setCustId(custId);
        
        // 3. QNA 저장 후 PK 얻기
        service.insertQna(qvo);
        int qnaQid = qvo.getQnaQid(); ////////////////// 이거 보고 있ㅇ므
        System.err.println(qnaQid + "가 첨부파일에 넣으려는 ID 임.");

        System.out.println("저장된 QNA PK: " + qnaQid);
        System.out.println("저장된 custId: " + qvo.getCustId());
        // 4. 첨부파일 저장 로직
        Collection<Part> parts = request.getParts();
        
        //atchFileService.saveAtchFileList(parts, qnaQid);  /// 이거 보는중
        AtchFileVO atchFileVO = atchFileService.saveAtchFileList(parts, qnaQid, request);
        System.out.println("📦 저장된 첨부파일 ID: " + (atchFileVO != null ? atchFileVO.getAtchFileId() : "없음"));

        qvo.setAtchFileVO(atchFileVO); // 반드시 넣어줘야 JSP에서 qvo.atchFileVO 사용할 수 있음
        
        
        /*
		 * AtchFileVO atchFile = atchFileService.saveAtchFileList(parts, qnaQid); /// 이거
		 * 보는중 if (atchFile != null) { atchFile.setQnaQid(qnaQid); // 필요하다면 AtchFileVO 내
		 * qnaQid를 통해 연계 저장하는 로직도 따로 가능 }
		 */

        
     // 첨부파일 로드 후 디버그 출력
		/*
		 * if (qvo.getAtchFileVO() != null &&
		 * !qvo.getAtchFileVO().getAtchFileDetailList().isEmpty()) {
		 * System.out.println("첨부파일 수: " +
		 * qvo.getAtchFileVO().getAtchFileDetailList().size());
		 * qvo.getAtchFileVO().getAtchFileDetailList().forEach(file -> {
		 * System.out.println("[파일명] " + file.getOrignlFileNm() + ", [파일 ID] " +
		 * file.getAtchFileId() + ", [파일 SN] " + file.getFileSn()); }); } else {
		 * System.out.println("첨부파일이 없습니다."); }
		 */
        if (qvo.getAtchFileVO() != null &&
        	    qvo.getAtchFileVO().getAtchFileDetailList() != null &&
        	    !qvo.getAtchFileVO().getAtchFileDetailList().isEmpty()) {

        	    System.out.println("첨부파일 수: " + qvo.getAtchFileVO().getAtchFileDetailList().size());
        	    qvo.getAtchFileVO().getAtchFileDetailList().forEach(file -> {
        	        System.out.println("[파일명] " + file.getOrignlFileNm() + ", [파일 ID] " + file.getAtchFileId() + ", [파일 SN] " + file.getFileSn());
        	    });

        	} else {
        	    System.out.println("첨부파일이 없습니다.");
        	}
        
        request.setAttribute("qna", qvo);
        
        
        // 5. 저장 후 페이지 이동
        response.sendRedirect(request.getContextPath() + "/QnaList.do");
    }
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.getRequestDispatcher("/qna/qnaWrite.jsp").forward(request, response);
	}
}
