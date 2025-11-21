package kr.or.ddit.dam.review.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSessionFactory;

import kr.or.ddit.dam.review.dao.IReviewDao;
import kr.or.ddit.dam.review.dao.ReviewDaoImpl;
import kr.or.ddit.dam.vo.BadwordVO;
import kr.or.ddit.dam.vo.PageVO;
import kr.or.ddit.dam.vo.ReviewVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class ReviewServiceImpl implements IReviewService {

	// 싱글톤 설정
	private SqlSessionFactory factory = MybatisUtil.getSqlSessionFactory();

	private static IReviewService service;
	private IReviewDao dao;
	
	private ReviewServiceImpl() {
		dao = ReviewDaoImpl.getInstance();
	}
	
	public static IReviewService getInstance() {
		if(service == null) service = new ReviewServiceImpl();
		return service;
	}
	// 싱글톤 설정 끝------------- 
	

	// 리뷰 리스트 출력
	@Override
	public List<ReviewVO> getReviewList(Map<String, Object> map) {
		
		return dao.getReviewList(map);
	}
	
	@Override
	public int getReviewCount(Long book_no) {
		
		return dao.getReviewCount(book_no);
	}
	
	
	// 수현) 페이징처리
	// Service에서만 사용하는 PageVO - 노 dao
	@Override
	public PageVO getPageInfo(int page, Long book_no) {

		int count = this.getReviewCount(book_no); // bookDao의 수행 값 : 전체 글 개수
		
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
	
	
	
	// 리뷰 작성
	@Override
	public int insertReview(ReviewVO rvo) {
		return dao.insertReview(rvo);
	}
	
	// 리뷰 중복 체크
	@Override
	public int reviewCheck(Map<String, Object> map) {
		return dao.reviewCheck(map);
	}

	// 좋아요 수 업데이트
	@Override
	public int likeUpdate(ReviewVO rvo) {
		return dao.likeUpdate(rvo);
	}

	// 좋아요 토글 - 좋아요 테이블에 삽입, 삭제, 사용자 좋아요 체크- 3개 수행
	@Override
	public int toggleLike(ReviewVO rvo) {

		try {
			// 1. 사용자가 좋아요 버튼을 눌렀는지 아닌지 체크
			int likeCheck = dao.userLikeCheck(rvo);
			
			if(likeCheck > 0) { 
				// 좋아요를 누른 상태였는데 다시 좋아요 버튼을 눌렀으니
				// 좋아요 취소 이벤트들 수행한다
				int deleteResult = dao.deleteLike(rvo);
				if(deleteResult > 0) {
					rvo.setLike_count(-1);
					int updateResult = dao.likeUpdate(rvo);
					return updateResult; // 성공:1, 실패:0 리턴
				}				
				return 0; // 삭제 실패
				
			} else {
				// 좋아요 버튼 안 누른 상태
				// 좋아요 실행 이벤트 시작
				int insertResult = dao.insertLike(rvo);
				if(insertResult > 0) {
					rvo.setLike_count(1);
					int updateResult = dao.likeUpdate(rvo);
					return updateResult; // 성공:1, 실패:0 리턴
				}
				return 0; // 삽입 실패
			}
			
		} catch(Exception e) {
			e.printStackTrace();
			return 0; // 오류일 때
		}
	}

	// 신고 수 업데이트
	@Override
	public int reportUpdate(ReviewVO rvo) {
		return dao.reportUpdate(rvo);
	}

	// 신고 내역 테이블 삽입
	@Override
	public int insertReport(ReviewVO rvo) {
		return dao.insertReport(rvo);
	}

	// 신고 토글 - 신고 테이블에 삽입, 삭제, 사용자 신고 체크- 3개 수행
	@Override
	public int toggleReport(ReviewVO rvo) {
		try {
			// 1. 사용자가 이미 신고했는지 체크
			int reportCheck = dao.userReportCheck(rvo);
			
			if(reportCheck > 0) {
				// 이미 신고한 상태
				return -1; // = 이미 신고함을 의미 -> result.jsp에 -1 flag 추가함!
			} else {
				// 아직 한 번도 신고 버튼을 누르지 않음
				int insertResult = dao.insertReport(rvo);
				if(insertResult > 0) {
					rvo.setReport_count(1);
					int updateResult = dao.reportUpdate(rvo);
					return updateResult; // 성공 : 1, 실패 : 0
				}
				return 0; // 삽입 실패 
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return 0; // 오류
		}
	}

	// 리뷰 수정
	@Override
	public int updateReview(ReviewVO rvo) {
		return dao.updateReview(rvo);
	}

	// 리뷰 삭제
	@Override
	public int deleteReview(int rvId) {
		return dao.deleteReview(rvId);
	}

	// 비속어
	@Override
	public List<BadwordVO> selectBadword() {
		return dao.selectBadword();
	}

}
