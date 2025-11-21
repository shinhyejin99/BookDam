package kr.or.ddit.dam.book.service;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.PageVO;
import kr.or.ddit.dam.vo.SearchVO;

public interface IBookService {

	// 수현) 내가 검색한 도서 리스트 가져오기 + 페이징
	// searchBooks() = listPerPage
	// map : start, end, stype, sword
	public List<BookVO> searchBooks(Map<String, Object> map);
	
	
	// 수현) 도서 검색에 의한 도서 수 구하는 메소드 - map : stype, sword
	public int getSearchCount(Map<String, Object> map);
	
	// 수현) 책 상세 페이지 출력하기
	public BookVO getBookDetail(Long bookNo);
	
	
	// 수현) 검색 책 리스트 출력을 위한 페이지 정보 구하기 - 전체 글 수, 전체 페이지수, start와 end
	// Service 에서만 씁니다
	public PageVO getPageInfo(int page, String stype, String sword);
	
	
	// 수현) 베스트셀러 페이지 출력하기
	public List<BookVO> getBestsellerList(Map<String, Object> map);
	
	// 수현) 베스트셀러 랭킹 가져오기
	public int getBestsellerRank(Long bookNo);
	
	//------------------------------수현
	// 카테고리용 페이지 정보
	public PageVO getPageInfoByCategory(int page, String category);

	// 카테고리용 총 개수  
	public int getCategoryBookCount(String category);

	// 수현) 카테고리별 도서 가져오기
	public List<BookVO> getBooksByCategory(Map<String, Object> map);
	
	//---------------------------------------------------
	
	// 도서 상세 정보 조회 (주희)
    BookVO getBookById(Long bookNo);
    
    // 카테고리 목록 조회 (주희)
    List<String> getDistinctCategories();
    
    // 도서 등록 (주희)
    int insertBook(BookVO book);

    // 도서 수정 (주희)
    int updateBook(BookVO book);

    // 도서 삭제 (주희)
    int deleteBook(Long book_no);
    
    public List<BookVO> searchBook(Map<String, Object> map);
    
    PageVO getPageInfo(SearchVO vo);

    int getSearchCounts(SearchVO vo);
    
    public BookVO selectBookByNo(String bookNo);
	
	// ----------------------------------------------------
	
	/**
	 * 환불 후, 주문한 도서들의 재고를 다시 채우는 메소드 (가영)
	 * @param paramMap 도서번호, 주문했던수량을 담은 map
	 * @param type 0이면 재고 마이너스, 1이면 재고 플러스
	 * @return 성공하면 1, 실패하면 0
	 */
	int updateStock(SqlSession sqlSession, Map<String, Object> paramMap);
}
