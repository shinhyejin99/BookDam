package kr.or.ddit.dam.vo;

//DB 테이블과 관련 X = config에 등록 X
// 페이징처리 관련 VO
public class SearchVO {

	// 책 검색할 때 필요해서 만들었습니다
	private int page;
	private String stype;
	private String sword;
	
	// 검색, 리스트 출력할 때 정렬 필요
	private String sortType;
	// 리뷰 리스트 출력용
	private Long book_no;
	private String tabType;
	
	// 리뷰에서 좋아요 / 신고 여부 때문에 mem_mail 필드 추가함
	private String mem_mail;
	
	private String category;
	private String startDate;
	private String endDate;
	private int minPrice;
	private int maxPrice;
	private int minStock;
	private int maxStock;

	
	
	
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public String getStype() {
		return stype;
	}
	public void setStype(String stype) {
		this.stype = stype;
	}
	public String getSword() {
		return sword;
	}
	public void setSword(String sword) {
		this.sword = sword;
	}
	
	public String getSortType() { return sortType; }
	public void setSortType(String sortType) { this.sortType = sortType; }
	
	public Long getBook_no() {
		return book_no;
	}
	public void setBook_no(Long book_no) {
		this.book_no = book_no;
	}
	public String getTabType() {
		return tabType;
	}
	public void setTabType(String tabType) {
		this.tabType = tabType;
	}
	public String getMem_mail() {
		return mem_mail;
	}
	public void setMem_mail(String mem_mail) {
		this.mem_mail = mem_mail;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public int getMinPrice() {
		return minPrice;
	}
	public void setMinPrice(int minPrice) {
		this.minPrice = minPrice;
	}
	public int getMaxPrice() {
		return maxPrice;
	}
	public void setMaxPrice(int maxPrice) {
		this.maxPrice = maxPrice;
	}
	public int getMinStock() {
		return minStock;
	}
	public void setMinStock(int minStock) {
		this.minStock = minStock;
	}
	public int getMaxStock() {
		return maxStock;
	}
	public void setMaxStock(int maxStock) {
		this.maxStock = maxStock;
	}
}
