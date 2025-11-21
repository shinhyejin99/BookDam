package kr.or.ddit.dam.review.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.BadwordVO;
import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.ReviewVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class ReviewDaoImpl implements IReviewDao {
	
	// 싱글톤 설정
	private static IReviewDao dao;
	private ReviewDaoImpl() {
		// TODO Auto-generated constructor stub
	}
	
	public static IReviewDao getInstance() {
		if (dao == null) dao = new ReviewDaoImpl();
		return dao;
	}
	// 싱글톤 설정 끝--------

	
	// 리뷰 작성 - insert
	@Override
	public int insertReview(ReviewVO rvo) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.insert("review.insertReview", rvo);
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

	// 리뷰 리스트 출력
	@Override
	public List<ReviewVO> getReviewList(Map<String, Object> map) {
		
		SqlSession session = MybatisUtil.getInstance();
		List<ReviewVO> list = null;
			
		try {
			list = session.selectList("review.getReviewList", map);
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

	@Override
	public int getReviewCount(Long book_no) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("review.getReviewCount", book_no);
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

	// 리뷰 중복 체크
	@Override
	public int reviewCheck(Map<String, Object> map) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("review.reviewCheck", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 좋아요 업데이트
	@Override
	public int likeUpdate(ReviewVO rvo) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.update("review.likeUpdate", rvo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 좋아요 테이블에 추가
	@Override
	public int insertLike(ReviewVO rvo) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.insert("review.insertLike", rvo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 좋아요 테이블에 삭제
	@Override
	public int deleteLike(ReviewVO rvo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.delete("review.deleteLike", rvo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 사용자 좋아요 체크
	@Override
	public int userLikeCheck(ReviewVO rvo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.selectOne("review.userLikeCheck", rvo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 신고 수 업데이트
	@Override
	public int reportUpdate(ReviewVO rvo) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.update("review.reportUpdate", rvo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close();
			}
		}
		return res;
	}

	// 신고 내역 테이블 - 삽입
	@Override
	public int insertReport(ReviewVO rvo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
			
		try {
			res = session.insert("review.insertReport", rvo);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.commit(); 
				session.close(); // 커넥션 풀의 커넥션을 반납
			}
		}
		return res;
	}

	// 사용자 신고 체크
	@Override
	public int userReportCheck(ReviewVO rvo) {
		
		SqlSession session = MybatisUtil.getInstance();
	    int res = 0;
	    try {
	        res = session.selectOne("review.userReportCheck", rvo);
	    } catch (PersistenceException e) {
	        e.printStackTrace();
	    } finally {
	        if(session != null) {
	        	session.commit();
	            session.close();
	        }
	    }
	    return res;
	}

	// 리뷰 수정
	@Override
	public int updateReview(ReviewVO rvo) {
		
		SqlSession session = MybatisUtil.getInstance();
	    int res = 0;
	    try {
	        res = session.update("review.updateReview", rvo);
	    } catch (PersistenceException e) {
	        e.printStackTrace();
	    } finally {
	        if(session != null) {
	        	session.commit();
	            session.close();
	        }
	    }
	    return res;
	}

	// 리뷰 삭제
	@Override
	public int deleteReview(int rvId) {
		
		SqlSession session = MybatisUtil.getInstance();
	    int res = 0;
	    try {
	    	session.delete("review.deleteReviewLike", rvId); // 좋아요 삭제
	    	session.delete("review.deleteReviewReport", rvId); // 신고 삭제
	        res = session.delete("review.deleteReview", rvId); // 리뷰 삭제
	    } catch (PersistenceException e) {
	        e.printStackTrace();
	    } finally {
	        if(session != null) {
	        	session.commit();
	            session.close();
	        }
	    }
	    return res;
	}

	@Override
	public List<BadwordVO> selectBadword() {
		
		SqlSession session = MybatisUtil.getInstance();
		List<BadwordVO> list = null;
			
		try {
			list = session.selectList("review.selectBadword");
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

}
