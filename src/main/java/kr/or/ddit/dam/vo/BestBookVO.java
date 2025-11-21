package kr.or.ddit.dam.vo;

public class BestBookVO {
	
	private String ageRange; //연령대("20대", "30대")
	private int memberCount; //연령대 회원수
	
	private long bookNo; //도서번호
	private String category; //카테고리
	private String bookTitle; //도서명
	private int bookPrice; //도서가격
	private String coverImg; //도서 이미지

	private int totalSales; //판매량
	private String salesDate; //판매일(기간별)

	public long getBookNo() {
		return bookNo;
	}
	public void setBookNo(long bookNo) {
		this.bookNo = bookNo;
	}
	public String getAgeRange() {
		return ageRange;
	}
	public void setAgeRange(String ageRange) {
		this.ageRange = ageRange;
	}
	public int getMemberCount() {
		return memberCount;
	}
	public void setMemberCount(int memberCount) {
		this.memberCount = memberCount;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getBookTitle() {
		return bookTitle;
	}
	public void setBookTitle(String bookTitle) {
		this.bookTitle = bookTitle;
	}
	public int getBookPrice() {
		return bookPrice;
	}
	public void setBookPrice(int bookPrice) {
		this.bookPrice = bookPrice;
	}
	public String getCoverImg() {
		return coverImg;
	}
	public void setCoverImg(String coverImg) {
		this.coverImg = coverImg;
	}
	public int getTotalSales() {
		return totalSales;
	}
	public void setTotalSales(int totalSales) {
		this.totalSales = totalSales;
	}
	public String getSalesDate() {
		return salesDate;
	}
	public void setSalesDate(String salesDate) {
		this.salesDate = salesDate;
	}
	@Override
	public String toString() {
		return "BestBookVO [ageRange=" + ageRange + ", memberCount=" + memberCount + ", bookNo=" + bookNo
				+ ", category=" + category + ", bookTitle=" + bookTitle + ", bookPrice=" + bookPrice + ", coverImg="
				+ coverImg + ", totalSales=" + totalSales + ", salesDate=" + salesDate + "]";
	}
	


	
	
	
}
