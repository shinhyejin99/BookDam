package kr.or.ddit.dam.review.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.BadwordVO;
import kr.or.ddit.dam.vo.ReviewVO;

public interface IReviewDao {

	// 리뷰 리스트 조회
	// map : start, end, 도서번호(book_id), sortType(정렬: 최신순, 공감순 등)
	public List<ReviewVO> getReviewList(Map<String, Object> map);
	
	// 해당 도서의 리뷰들 수 조회
	public int getReviewCount(Long book_no);
	
	// 리뷰 작성 - insert
	public int insertReview(ReviewVO rvo);
	
	// 리뷰 중복 체크 - 회원은 1권당 1개의 리뷰만 작성가능함
	public int reviewCheck(Map<String, Object> map);
	
	// 좋아요 업데이트
	public int likeUpdate(ReviewVO rvo);
	
	// 좋아요 테이블 추가
	public int insertLike(ReviewVO rvo);
	
	// 좋아요 테이블 삭제
	public int deleteLike(ReviewVO rvo);
	
	// 사용자의 좋아요 체크
	public int userLikeCheck(ReviewVO rvo);
	
	// 신고 수 업데이트
	public int reportUpdate(ReviewVO rvo);
	
	// 신고 테이블 추가
	public int insertReport(ReviewVO rvo);
	
	// 사용자의 신고 체크
	public int userReportCheck(ReviewVO rvo);
	
	// 리뷰 수정
	public int updateReview(ReviewVO rvo);
	
	// 리뷰 삭제
	public int deleteReview(int rvId);
	
	// 비속어
	public List<BadwordVO> selectBadword();
}
