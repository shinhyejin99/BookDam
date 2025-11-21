package kr.or.ddit.dam.vo;

public class ReviewVO {
	
	private int rv_id;
	private String mem_nickname;
	private String rv_content; // CLOB 타입
	private String rv_date;
	private int rating;
	private String purchased;
	private String spoiler;
	private int like_count;
	private int report_count;
	private Long book_no;
	private String mem_mail;
	
	// review.xml에서 리뷰 리스트 출력 sql 수행하고 = 사용자의 좋아요/신고 여부(int)를 받기 위해 생성한 컬럼
	// (0:안함, 1:함)
	private int user_liked; // 현재 사용자가 좋아요한 여부
	private int user_reported; // 현재 사용자가 신고한 여부
	
	public ReviewVO() {
		// TODO Auto-generated constructor stub
	}

	public int getRv_id() {
		return rv_id;
	}

	public void setRv_id(int rv_id) {
		this.rv_id = rv_id;
	}

	public String getRv_content() {
		return rv_content;
	}

	public void setRv_content(String rv_content) {
		this.rv_content = rv_content;
	}

	public String getRv_date() {
		return rv_date;
	}

	public void setRv_date(String rv_date) {
		this.rv_date = rv_date;
	}

	public int getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public String getPurchased() {
		return purchased;
	}

	public void setPurchased(String purchased) {
		this.purchased = purchased;
	}

	public String getSpoiler() {
		return spoiler;
	}

	public void setSpoiler(String spoiler) {
		this.spoiler = spoiler;
	}

	public int getLike_count() {
		return like_count;
	}

	public void setLike_count(int like_count) {
		this.like_count = like_count;
	}

	public int getReport_count() {
		return report_count;
	}

	public void setReport_count(int report_count) {
		this.report_count = report_count;
	}

	public Long getBook_no() {
		return book_no;
	}

	public void setBook_no(Long book_no) {
		this.book_no = book_no;
	}

	public String getMem_mail() {
		return mem_mail;
	}

	public void setMem_mail(String mem_mail) {
		this.mem_mail = mem_mail;
	}

	public int getUser_liked() {
		return user_liked;
	}

	public void setUser_liked(int user_liked) {
		this.user_liked = user_liked;
	}

	public int getUser_reported() {
		return user_reported;
	}

	public void setUser_reported(int user_reported) {
		this.user_reported = user_reported;
	}

	public String getMem_nickname() {
		return mem_nickname;
	}

	public void setMem_nickname(String mem_nickname) {
		this.mem_nickname = mem_nickname;
	}

}
