package kr.or.ddit.dam.vo;

//DB에 없고 자바에서만 사용하는 VO -> config에 작성 X
//페이징처리 관련 VO
public class PageVO {

	private int start; //한 페이지에서 보여줄 글의 시작
	private int end; //
	
	private int startPage;
	private int endPage;
	
	private int totalPage;
	
	// 추후에 페이지 수 변경할 수 있음
	private static int perList = 7; // 출력될 글 수
	private static int perPage = 5; // 페이지 수
	
	public int getStart() {
		return start;
	}
	public void setStart(int start) {
		this.start = start;
	}
	public int getEnd() {
		return end;
	}
	public void setEnd(int end) {
		this.end = end;
	}
	public int getStartPage() {
		return startPage;
	}
	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}
	public int getEndPage() {
		return endPage;
	}
	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public static int getPerList() {
		return perList;
	}
	public static void setPerList(int perList) {
		PageVO.perList = perList;
	}
	public static int getPerPage() {
		return perPage;
	}
	public static void setPerPage(int perPage) {
		PageVO.perPage = perPage;
	}
}
