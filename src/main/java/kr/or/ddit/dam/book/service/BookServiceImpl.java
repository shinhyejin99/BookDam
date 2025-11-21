package kr.or.ddit.dam.book.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import kr.or.ddit.dam.book.dao.BookDaoImpl;
import kr.or.ddit.dam.book.dao.IBookDao;
import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.PageVO;
import kr.or.ddit.dam.vo.SearchVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class BookServiceImpl implements IBookService {
	
	private SqlSessionFactory factory = MybatisUtil.getSqlSessionFactory();

	// 싱글톤 설정
	private static IBookService bookService;
	private IBookDao bookDao;
	
	private BookServiceImpl() {
		bookDao = BookDaoImpl.getInstance();
	}
	
	public static IBookService getInstance() {
		if(bookService == null) bookService = new BookServiceImpl();
		return bookService;
	}
	// 싱글톤 설정 끝-------------

	
	
	// 수현) 내가 검색한 도서 리스트 가져오기 + 페이징
	@Override
	public List<BookVO> searchBooks(Map<String, Object> map) {
		return bookDao.searchBooks(map);
	}

	// 수현) 검색된 도서 수 구하는 메소드 - 동적쿼리 이용
	// map : stype, sword
	@Override
	public int getSearchCount(Map<String, Object> map) {
		return bookDao.getSearchCount(map);
	}
	
	// 책 상세정보 가져오는 메소드
	@Override
	public BookVO getBookDetail(Long bookNo) {
		return bookDao.getBookDetail(bookNo);
	}

	// 수현) 페이징처리
	// Service에서만 사용하는 PageVO - 노 dao
	@Override
	public PageVO getPageInfo(int page, String stype, String sword) {
		
		// 전체 글 갯수 구하기
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("stype", stype); // 파라미터인 stype이 map에 put됨!
		map.put("sword", sword); // 파라미터인 sword가 map에 put됨!
		
		int count = this.getSearchCount(map); // bookDao의 수행 값 : 전체 글 개수
		
		// 전체 페이지 수 구하기(한 페이지 당 7개씩 게시글 or 도서정보를 찍어라) - plist : 7
		int plist = PageVO.getPerList(); //perList = 7;  출력될 글 수
		int totalPage = (int)Math.ceil(count / (double)plist); // 반올림
		
		// start, end 구하기 - 이건 현재 페이지가 달라짐에 따라 달라짐
		// ex) 1페이지 - 1,7 / 2페이지 - 8,14 
		// end값이 count(검색된 도서 리스트 or 총 게시글 수)를 넘어가면 안되기 때문에 
		// if문 사용해서 end값이 count값보다 크면 count값을 end로 한다.
		int start = (page-1) * plist + 1;
		int end = start + plist - 1;
		if(end > count) end = count;
		
		// 시작 페이지와 끝 페이지 구하기 = 페이지 정보
		// 1페이지 : < 1,2,3,4,5 >  2페이지 : < 1,2,3,4,5 >  3페이지 : < 1,2,3,4,5 > ..
		// 6페이지 : < 6,7,8,9,10 > 7페이지 : < 6,7,8,9,10>...
		int ppage = PageVO.getPerPage(); //perPage = 5;  페이지 수
		int startPage = ((page-1) / ppage * ppage) + 1;
		int endPage = startPage + ppage - 1 ;
		if(endPage > totalPage) endPage = totalPage;
		
		/*
		ex) page(현재 페이지 : 7) 일 때 시작페이지번호(startPage)와 마지막페이지(endPage) 번호는?
		  - startPage : ((7-1) / 5 * 5) +1 = (1.xx) * 5 +1 = 6.xx => 6
		  - endPage : 6 + 5 -1 = 10
		   < 6 7 8 9 10 >    => 맞다!
		*/
		
		// 페이지 계산 끝 -> 이제 값을 pvo객체에 담아 사용하도록 한다
		PageVO pvo = new PageVO();
		pvo.setStart(start);
		pvo.setEnd(end);
		pvo.setStartPage(startPage);
		pvo.setEndPage(endPage);
		pvo.setTotalPage(totalPage);
		
		return pvo;
	}
	
	// 베스트셀러 페이지 출력
	@Override
	public List<BookVO> getBestsellerList(Map<String, Object> map) {
		return bookDao.getBestsellerList(map);
	}
	
	// 베스트셀러 랭킹 가져오기
	@Override
	public int getBestsellerRank(Long bookNo) {
		return bookDao.getBestsellerRank(bookNo);
	}
	
	// 카테고리용 페이지
	@Override
	public PageVO getPageInfoByCategory(int page, String category) {
		
		// 카테고리별 전체 글 갯수 구하기
	    int count = this.getCategoryBookCount(category); // 카테고리용 count 메소드 호출
	    
	    // 전체 페이지 수 구하기(한 페이지 당 7개씩 게시글 or 도서정보를 찍어라) - plist : 7
	    int plist = PageVO.getPerList(); //perList = 7; 출력될 글 수
	    int totalPage = (int)Math.ceil(count / (double)plist); // 반올림
	    
	    // start, end 구하기 - 이건 현재 페이지가 달라짐에 따라 달라짐
	    // ex) 1페이지 - 1,7 / 2페이지 - 8,14
	    // end값이 count(검색된 도서 리스트 or 총 게시글 수)를 넘어가면 안되기 때문에
	    // if문 사용해서 end값이 count값보다 크면 count값을 end로 한다.
	    int start = (page-1) * plist + 1;
	    int end = start + plist - 1;
	    if(end > count) end = count;
	    
	    // 시작 페이지와 끝 페이지 구하기 = 페이지 정보
	    // 1페이지 : < 1,2,3,4,5 > 2페이지 : < 1,2,3,4,5 > 3페이지 : < 1,2,3,4,5 > ..
	    // 6페이지 : < 6,7,8,9,10 > 7페이지 : < 6,7,8,9,10>...
	    int ppage = PageVO.getPerPage(); //perPage = 5; 페이지 수
	    int startPage = ((page-1) / ppage * ppage) + 1;
	    int endPage = startPage + ppage - 1 ;
	    if(endPage > totalPage) endPage = totalPage;
	    
	    // 페이지 계산 끝 -> 이제 값을 pvo객체에 담아 사용하도록 한다
	    PageVO pvo = new PageVO();
	    pvo.setStart(start);
	    pvo.setEnd(end);
	    pvo.setStartPage(startPage);
	    pvo.setEndPage(endPage);
	    pvo.setTotalPage(totalPage);
	    
	    return pvo;
	}

	// 카테고리용 카운트
	@Override
	public int getCategoryBookCount(String category) {
		return bookDao.getCategoryBookCount(category);
	}

	// 카테고리용 정보 가져오기
	@Override
	public List<BookVO> getBooksByCategory(Map<String, Object> map) {
		return bookDao.getBooksByCategory(map);
	}
	
	

	// 주희-----------------------------------------------
	
	@Override
	public BookVO getBookById(Long  bookNo) {
	    return bookDao.getBookById(bookNo);
	}

	public List<String> getDistinctCategories() {
		return bookDao.getDistinctCategories();
	}
	
    @Override
    public int insertBook(BookVO vo) {
    	return bookDao.insertBook(vo);
    }

    @Override
    public int updateBook(BookVO vo) {
    	return bookDao.updateBook(vo);
    }

    @Override
    public int deleteBook(Long book_no) {
    	return bookDao.deleteBook(book_no);
    }

	@Override
	public List<BookVO> searchBook(Map<String, Object> map){
		return bookDao.searchBook(map);
	}

	@Override
	public PageVO getPageInfo(SearchVO vo) {
		
		int count = this.getSearchCounts(vo);
		
		System.out.println("count===" + count);
		
		
		// 전체 페이지 수 구하기(한 페이지 당 7개씩 게시글 or 도서정보를 찍어라) - plist : 7
		int plist = PageVO.getPerList(); //perList = 7;  출력될 글 수
		int totalPage = (int)Math.ceil(count / (double)plist); // 반올림
		
		// start, end 구하기 - 이건 현재 페이지가 달라짐에 따라 달라짐
		// ex) 1페이지 - 1,7 / 2페이지 - 8,14 
		// end값이 count(검색된 도서 리스트 or 총 게시글 수)를 넘어가면 안되기 때문에 
		// if문 사용해서 end값이 count값보다 크면 count값을 end로 한다.
		int start = (vo.getPage()-1) * plist + 1;
		int end = start + plist - 1;
		if(end > count) end = count;
		
		// 시작 페이지와 끝 페이지 구하기 = 페이지 정보
		// 1페이지 : < 1,2,3,4,5 >  2페이지 : < 1,2,3,4,5 >  3페이지 : < 1,2,3,4,5 > ..
		// 6페이지 : < 6,7,8,9,10 > 7페이지 : < 6,7,8,9,10>...
		int ppage = PageVO.getPerPage(); //perPage = 5;  페이지 수
		int startPage = ((vo.getPage()-1) / ppage * ppage) + 1;
		int endPage = startPage + ppage - 1 ;
		if(endPage > totalPage) endPage = totalPage;
		
		/*
		ex) page(현재 페이지 : 7) 일 때 시작페이지번호(startPage)와 마지막페이지(endPage) 번호는?
		  - startPage : ((7-1) / 5 * 5) +1 = (1.xx) * 5 +1 = 6.xx => 6
		  - endPage : 6 + 5 -1 = 10
		   < 6 7 8 9 10 >    => 맞다!
		*/
		
		// 페이지 계산 끝 -> 이제 값을 pvo객체에 담아 사용하도록 한다
		PageVO pvo = new PageVO();
		pvo.setStart(start);
		pvo.setEnd(end);
		pvo.setStartPage(startPage);
		pvo.setEndPage(endPage);
		pvo.setTotalPage(totalPage);
		
		System.out.println("start =" + start );
		System.out.println("end =" + end );
		System.out.println("startPage =" + startPage );
		System.out.println("endPage =" + endPage );
		System.out.println("totalPage =" + totalPage );
		return pvo;
	}

	@Override
	public int getSearchCounts(SearchVO vo) {
		// TODO Auto-generated method stub
		return bookDao.getSearchCounts(vo);
	}
	
	@Override
	public BookVO selectBookByNo(String bookNo) {
	    return bookDao.selectBookByNo(bookNo);
	}

	
	//---------------------------------------------------
	
	// 환불 후, 주문한 도서들의 재고를 다시 채우는 메소드 (가영)
	@Override
	public int updateStock(SqlSession sqlSession, Map<String, Object> paramMap) {
		return bookDao.updateStock(sqlSession, paramMap);
	}

	
}
