package kr.or.ddit.dam.admin;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.IQnaService;
import kr.or.ddit.dam.qna.service.QnaServiceImpl;
import kr.or.ddit.dam.vo.QnaVO;

/**
 * Servlet implementation class QnaAdminList
 */
@WebServlet("/admin/QnaAdminList.do")
public class QnaAdminList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private IQnaService service = QnaServiceImpl.getService();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QnaAdminList() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    

	    // 1. 파라미터 수집
	    String stype = request.getParameter("stype");
	    String sword = request.getParameter("sword");
	    String status = request.getParameter("status");

	    // 2. 파라미터 맵 저장
	    Map<String, Object> paramMap = new HashMap<>();
	    boolean hasSearch = false;

	    if (stype != null && !stype.isEmpty() && sword != null && !sword.isEmpty()) {
	        paramMap.put("stype", stype);
	        paramMap.put("sword", sword.trim());
	        hasSearch = true;
	    }

	    if (status != null && !status.isEmpty()) {
	        paramMap.put("status", status);
	        hasSearch = true;
	    }

	    // 3. 서비스 호출
	    List<QnaVO> qnaList;
	    if (hasSearch) {
	        qnaList = service.getAdminQnaList(paramMap); // 조건 검색
	    } else {
	        qnaList = service.getAllQna(); // 전체 목록
	    }

	    // 4. JSP로 데이터 전달
	    request.setAttribute("qnaList", qnaList);
	    request.setAttribute("stype", stype);
	    request.setAttribute("sword", sword);
	    request.setAttribute("status", status);

	    // 5. 포워딩
	    request.getRequestDispatcher("/admin/qna/qnaAdminList.jsp").forward(request, response);
	    
	    //전체 문의사항 조회
	    //List<QnaVO> qnaList = service.getAllQna();
	    
		//조회된 목록 저장
		//request.setAttribute("qnaList", qnaList);
		
		//포워딩
		//request.getRequestDispatcher("/admin/qna/qnaAdminList.jsp").forward(request, response);
	}


	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
	
}
