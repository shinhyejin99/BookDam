package kr.or.ddit.dam.book.dao;

import java.util.List;

import kr.or.ddit.dam.vo.BestBookVO;

public interface IBestBookDao {

	//베스트셀러 조회
	public List<BestBookVO> selectBestBook();
	
	//연령대별 베스트셀러 조회
	public List<BestBookVO> selectAge(String ageRange);
	
	//카테고리별 베스트셀러 조회
	//params 라는 이름의 Map<String, String>에 startDate와 endDate를 담아서 한꺼번에 전달
	public String selectCategory();
	
	//카테고리내 베스트셀러
	public List<BestBookVO> selectTopCategory(String category);

}
