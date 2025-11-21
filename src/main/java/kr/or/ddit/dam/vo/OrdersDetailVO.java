package kr.or.ddit.dam.vo;

public class OrdersDetailVO {
	private long order_no;
	private long book_no;
	private int order_qty;
	private int order_price;
	private int earned_mileage;
    private String cover_img;
    private String book_title;
    private String BOOK_AUTHOR;
    private String publisher;
    
	private long payment_no;
	private String payment_date;
	private String payment_status;
	private int payment_amt;
	private int use_mileage;
	private int payment_tool_no;
    
	public long getOrder_no() {
		return order_no;
	}
	public void setOrder_no(long order_no) {
		this.order_no = order_no;
	}
	public long getBook_no() {
		return book_no;
	}
	public void setBook_no(long book_no) {
		this.book_no = book_no;
	}
	public int getOrder_qty() {
		return order_qty;
	}
	public void setOrder_qty(int order_qty) {
		this.order_qty = order_qty;
	}
	public int getOrder_price() {
		return order_price;
	}
	public void setOrder_price(int order_price) {
		this.order_price = order_price;
	}
	public int getEarned_mileage() {
		return earned_mileage;
	}
	public void setEarned_mileage(int earned_mileage) {
		this.earned_mileage = earned_mileage;
	}
	public String getCover_img() {
		return cover_img;
	}
	public void setCover_img(String cover_img) {
		this.cover_img = cover_img;
	}
	public String getBook_title() {
		return book_title;
	}
	public void setBook_title(String book_title) {
		this.book_title = book_title;
	}
	public String getBOOK_AUTHOR() {
		return BOOK_AUTHOR;
	}
	public void setBOOK_AUTHOR(String bOOK_AUTHOR) {
		BOOK_AUTHOR = bOOK_AUTHOR;
	}
	public String getPublisher() {
		return publisher;
	}
	public void setPublisher(String publisher) {
		this.publisher = publisher;
	}
	public long getPayment_no() {
		return payment_no;
	}
	public void setPayment_no(long payment_no) {
		this.payment_no = payment_no;
	}
	public String getPayment_date() {
		return payment_date;
	}
	public void setPayment_date(String payment_date) {
		this.payment_date = payment_date;
	}
	public String getPayment_status() {
		return payment_status;
	}
	public void setPayment_status(String payment_status) {
		this.payment_status = payment_status;
	}
	public int getPayment_amt() {
		return payment_amt;
	}
	public void setPayment_amt(int payment_amt) {
		this.payment_amt = payment_amt;
	}
	public int getUse_mileage() {
		return use_mileage;
	}
	public void setUse_mileage(int use_mileage) {
		this.use_mileage = use_mileage;
	}
	public int getPayment_tool_no() {
		return payment_tool_no;
	}
	public void setPayment_tool_no(int payment_tool_no) {
		this.payment_tool_no = payment_tool_no;
	}
	
	
	
}
