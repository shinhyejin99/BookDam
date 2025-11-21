package kr.or.ddit.dam.util;

import kr.or.ddit.dam.vo.SearchVO;

public class PaginationInfo {
	private int totalRecord;
	private int totalPage;
	
	private int perList;
	private int perPage;
	
	private int page;
	
	private int startPage;
	private int endPage;
	private int start;
	private int end;
	
	private SearchVO vo;
	
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}
	
	public int getTotalPage() {
		totalPage = totalRecord / perList;
		return totalPage;
	}
}
