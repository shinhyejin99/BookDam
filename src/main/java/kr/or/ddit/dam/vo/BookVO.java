package kr.or.ddit.dam.vo;

public class BookVO {

	private Long book_no;
	private String book_title;
	private String book_author;
	private String book_pubdate;
	private String book_description;
	private Integer book_price;
	private String publisher;
	private String category;
	private String cover_img; // 이미지...
	private Integer book_page;
	private Integer stock_qty;
	//-- DB 컬럼들---▼ 추가로 필요한 컬럼 생성 ▼
	
	// 수현) 책 검색용 컬럼 추가
	private double avgRating; // 평균별점(도서정보 출력용)
	private int reviewCount; // 리뷰수(도서정보 출력용)
	private int totalSales; // 총 판매량 계산(정렬용)
	
	// 수현) 베스트셀러 출력용 필드 추가
	private int best_rank;
	
	// 주희(수정/등록 모드)
	private String mode;
	

	// Getter, Setter 메소드
	public Long getBook_no() {
	    return book_no;
	}

	public void setBook_no(Long book_no) {
	    this.book_no = book_no;
	}

	public String getBook_title() {
		return book_title;
	}

	public void setBook_title(String book_title) {
		this.book_title = book_title;
	}

	public String getBook_author() {
		return book_author;
	}

	public void setBook_author(String book_author) {
		this.book_author = book_author;
	}

	public String getBook_pubdate() {
		return book_pubdate;
	}

	public void setBook_pubdate(String book_pubdate) {
		this.book_pubdate = book_pubdate;
	}

	public String getBook_description() {
		return book_description;
	}

	public void setBook_description(String book_description) {
		this.book_description = book_description;
	}

	public Integer getBook_price() {
		return book_price;
	}

	public void setBook_price(Integer book_price) {
		this.book_price = book_price;
	}

	public String getPublisher() {
		return publisher;
	}

	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getCover_img() {
		return cover_img;
	}

	public void setCover_img(String cover_img) {
		this.cover_img = cover_img;
	}

	public Integer getBook_page() {
		return book_page;
	}

	public void setBook_page(Integer book_page) {
		this.book_page = book_page;
	}

	public Integer getStock_qty() {
		return stock_qty;
	}

	public void setStock_qty(Integer stock_qty) {
		this.stock_qty = stock_qty;
	}


	public double getAvgRating() {
		return avgRating;
	}


	public void setAvgRating(double avgRating) {
		this.avgRating = avgRating;
	}


	public int getReviewCount() {
		return reviewCount;
	}


	public void setReviewCount(int reviewCount) {
		this.reviewCount = reviewCount;
	}


	public int getTotalSales() {
		return totalSales;
	}


	public void setTotalSales(int totalSales) {
		this.totalSales = totalSales;
	}


	public int getBest_rank() {
		return best_rank;
	}


	public void setBest_rank(int best_rank) {
		this.best_rank = best_rank;
	}
	
	public String getMode() {
		return mode;
	}
	
	public void setMode(String mode) {
		this.mode = mode;
	}
}
