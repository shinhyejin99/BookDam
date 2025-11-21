package kr.or.ddit.dam.vo;

public class OrderManageVO {
	
	private String orderNo;         // 주문번호
    private String custId;          // 주문자 ID
    private int totalAmt;           // 총 금액

    private String bookTitle;       // 도서명
    private int orderQty;           // 주문 수량
    private int orderPrice;         // 도서 가격

    private String orderName;       // 수령인 성함
    private String orderZip;        // 우편번호
    private String orderAddr1;      // 기본주소
    private String orderAddr2;      // 상세주소

    private String orderStatus;     // 주문 상태 (배송전, 배송중, 배송완료)
    private String paymentStatus;   // 결제 상태

    private int rn;
    
	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public int getTotalAmt() {
		return totalAmt;
	}

	public void setTotalAmt(int totalAmt) {
		this.totalAmt = totalAmt;
	}

	public String getBookTitle() {
		return bookTitle;
	}

	public void setBookTitle(String bookTitle) {
		this.bookTitle = bookTitle;
	}

	public int getOrderQty() {
		return orderQty;
	}

	public void setOrderQty(int orderQty) {
		this.orderQty = orderQty;
	}

	public int getOrderPrice() {
		return orderPrice;
	}

	public void setOrderPrice(int orderPrice) {
		this.orderPrice = orderPrice;
	}

	public String getOrderName() {
		return orderName;
	}

	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}

	public String getOrderZip() {
		return orderZip;
	}

	public void setOrderZip(String orderZip) {
		this.orderZip = orderZip;
	}

	public String getOrderAddr1() {
		return orderAddr1;
	}

	public void setOrderAddr1(String orderAddr1) {
		this.orderAddr1 = orderAddr1;
	}

	public String getOrderAddr2() {
		return orderAddr2;
	}

	public void setOrderAddr2(String orderAddr2) {
		this.orderAddr2 = orderAddr2;
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public int getRn() {
	    return rn;
	}
	
	public void setRn(int rn) {
	    this.rn = rn;
	}

	public String getPaymentStatus() {
		return paymentStatus;
	}

	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}
}
