package kr.or.ddit.dam.book.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.book.service.BestBookServiceImpl;
import kr.or.ddit.dam.book.service.IBestBookService;
import kr.or.ddit.dam.vo.BestBookVO;

/**
 * Servlet implementation class BestBook
 */
@WebServlet("/BestBook.do")
public class BestBook extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	private IBestBookService service = BestBookServiceImpl.getService();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BestBook() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("진입"); 
		
		//베스트셀러
		List<BestBookVO> bestList = service.selectBestBook();
		request.setAttribute("bestList", bestList);
		
		System.out.println("베스트셀러 수: " + bestList.size());
		//for (BestBookVO vo : bestList) {
		//    System.out.println(vo.getBookTitle());
		//}
		for (BestBookVO vo : bestList) {
		    System.out.println("책 제목: " + vo.getBookTitle());
		    System.out.println("이미지 경로: " + vo.getCoverImg());
		}		

		//30대 인기도서
		List<BestBookVO> ageList = service.selectAge("20대");
		request.setAttribute("ageList", ageList);
		
		//인기 카테고리
		String topCategory = service.selectCategory();
        List<BestBookVO> categoryList = service.selectTopCategory(topCategory);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("topCategory", topCategory); // 카테고리명도 출력용으로
        
        //view로 포워딩
        request.getRequestDispatcher("/main/bookdam_main.jsp").forward(request, response);

		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
