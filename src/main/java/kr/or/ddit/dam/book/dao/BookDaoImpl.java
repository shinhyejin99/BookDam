package kr.or.ddit.dam.book.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.SearchVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class BookDaoImpl implements IBookDao {

	// 싱글톤 설정
	private static IBookDao bookDao;
	
	private BookDaoImpl() {
		// TODO Auto-generated constructor stub
	}
	
	public static IBookDao getInstance() {
		if (bookDao == null) bookDao = new BookDaoImpl();
		
		return bookDao;
	}
	// 싱글톤 설정 끝------------

	// 수현) 도서검색
	@Override
	public List<BookVO> searchBooks(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		List<BookVO> list = null;
			
		try {
			list = session.selectList("book.searchBooks", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return list;
	}

	// 수현) 도서검색 건수
	@Override
	public int getSearchCount(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("book.getSearchCount", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}
	
	// 수현) 책 상세 정보 가져오는 메소드
	@Override
	public BookVO getBookDetail(Long bookNo) {
		
		SqlSession session = MybatisUtil.getInstance();
		BookVO bvo = null;
			
		try {
			bvo = session.selectOne("book.getBookDetail", bookNo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}

		return bvo;
	}
	
	// 수현) 베스트셀러
	@Override
	public List<BookVO> getBestsellerList(Map<String, Object> map) {
		
		SqlSession session = MybatisUtil.getInstance();
		List<BookVO> list = null;
			
		try {
			list = session.selectList("book.getBestsellerList", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return list;
	}
	
	// 베스트셀러 랭킹 가져오기
	@Override
	public int getBestsellerRank(Long bookNo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("book.getBestsellerRank", bookNo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}
	
	// 카테고리 카운트
	@Override
	public int getCategoryBookCount(String category) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("book.getCategoryBookCount", category);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 카테고리 정보 가져오기
	@Override
	public List<BookVO> getBooksByCategory(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		List<BookVO> list = null;
			
		try {
			list = session.selectList("book.getBooksByCategory", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return list;
	}
	
	
	// 주희------------------------------------------------
	
	@Override
	public BookVO getBookById(Long bookNo) {
		SqlSession session = MybatisUtil.getInstance();
		BookVO bvo = null;
		
	    try {
	        bvo = session.selectOne("book.selectBookById", bookNo);
	    } catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
	    return bvo;
	}

	@Override
	public List<String> getDistinctCategories() {
		SqlSession session = MybatisUtil.getInstance();
		List<String> list = null;
		
		try {
			list = session.selectList("book.distinctCategories");
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return list;
	}
	
	@Override
	public int insertBook(BookVO book) {
		SqlSession session = MybatisUtil.getInstance();
		int bvo = 0;
		
	    try {
	        bvo = session.insert("book.insertBook", book);
	    } catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
	    return bvo;
	}

	@Override
	public int updateBook(BookVO book) {
		SqlSession session = MybatisUtil.getInstance();
		int bvo = 0;
		
	    try {
	        bvo = session.update("book.updateBook", book);
	    } catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
	    return bvo;
	}
	
	public int deleteBook(Long book_no) {
		SqlSession session = MybatisUtil.getInstance();
		int bvo = 0;
		
	    try {
	        bvo = session.delete("book.deleteBook", book_no);
	    } catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
	    return bvo;
	}
	
	@Override
	public List<BookVO> searchBook(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		List<BookVO> list = null;
		
		try {
			//list = session.selectList("book.searchBook", map);
			list = session.selectList("book.searchBook", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return list;
	}

	@Override
	public int getSearchCounts(SearchVO vo) {
		// TODO Auto-generated method stub
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("book.getSearchCounts", vo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); // finally에서 commit!
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}
	
	@Override
	public BookVO selectBookByNo(String book_no) {
		
		SqlSession session = MybatisUtil.getInstance();
		BookVO bvo = null;
			
		try {
			bvo = session.selectOne("book.selectBookByNo", book_no);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return bvo;
	}
	
//---------------------------------------------------------------------

	// 주문한 도서들의 재고를 다시 채우고 차감하는 메소드 (가영)
	@Override
	public int updateStock(SqlSession sqlSession, Map<String, Object> paramMap) {
		
		int cnt = 0;
		
		try {
			cnt = sqlSession.update("book.updateStock", paramMap);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			// sqlSession.commit(); commit, close 는 서블릿에서
			// sqlSession.close();
		}
		
		return cnt;
	}

	
}
