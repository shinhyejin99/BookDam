package kr.or.ddit.dam.book.controller;

import kr.or.ddit.dam.book.service.BookServiceImpl;
import kr.or.ddit.dam.book.service.IBookService;
import kr.or.ddit.dam.util.StreamData;
import kr.or.ddit.dam.vo.BookVO;

import java.io.IOException;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class BookManage
 */
@WebServlet("/BookManage.do")
public class BookManage extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public BookManage() {
    	super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        String cmd = req.getParameter("cmd");
        String bookNoStr = req.getParameter("book_no");

        
        int result=0;
        
        if ("delete".equals(cmd) && bookNoStr != null) {
            
            	Long book_no = Long.parseLong(bookNoStr);
            	
                IBookService service = BookServiceImpl.getInstance();
                
                result = service.deleteBook(book_no);
                
                req.setAttribute("result", result);
                
                req.getRequestDispatcher("/bookManage/result.jsp").forward(req, res);
                
                
                
                
               
        }     
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/plain; charset=UTF-8");

        
        String reqData = StreamData.getChange(req);
        System.out.println("reqData==" + reqData);
        
        
        Gson   gson = new Gson();
        
        BookVO  book = gson.fromJson(reqData, BookVO.class);
        
        
        IBookService service = BookServiceImpl.getInstance();
        
        int result=0;
        
        if(book.getMode().equals("edit")){
        	result = service.updateBook(book);
        }else {
        	result =service.insertBook(book);
        }
        
        
        req.setAttribute("result", result);
        
        req.getRequestDispatcher("/bookManage/result.jsp").forward(req, res);
        
        
		/*
		 * String mode = req.getParameter("mode");
		 * 
		 * // 싱글톤 방식으로 서비스 객체 얻기 IBookService service = BookServiceImpl.getInstance();
		 * 
		 * BookVO book = new BookVO();
		 * 
		 * book.setBook_no(Long.parseLong(req.getParameter("book_no")));
		 * 
		 * // BookVO 필드명에 맞춰 setter 호출 (언더스코어 포함)
		 * book.setBook_title(req.getParameter("book_title"));
		 * book.setBook_author(req.getParameter("book_author"));
		 * 
		 * // book_pubdate는 String 타입으로 받음
		 * book.setBook_pubdate(req.getParameter("book_pubdate"));
		 * book.setBook_description(req.getParameter("book_description"));
		 * book.setBook_price(Integer.parseInt(req.getParameter("book_price")));
		 * book.setPublisher(req.getParameter("publisher"));
		 * book.setCategory(req.getParameter("category"));
		 * book.setCover_img(req.getParameter("cover_img"));
		 * book.setBook_page(Integer.parseInt(req.getParameter("book_page")));
		 * book.setStock_qty(Integer.parseInt(req.getParameter("stock_qty")));
		 * 
		 * try { if ("edit".equals(mode)) { service.updateBook(book);
		 * res.getWriter().write("도서 수정 완료"); } else { service.insertBook(book);
		 * res.getWriter().write("도서 등록 완료"); } } catch (Exception e) {
		 * e.printStackTrace(); res.setStatus(500); res.getWriter().write("에러 발생: " +
		 * e.getMessage()); }
		 */
    }

}