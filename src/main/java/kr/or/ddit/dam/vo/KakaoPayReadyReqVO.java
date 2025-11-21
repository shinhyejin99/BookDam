package kr.or.ddit.dam.vo;

public class KakaoPayReadyReqVO {
	private String cid; // 가맹점 코드, 10자
	private String partner_order_id; // 가맹점 주문번호, 최대 100자
	private String partner_user_id; //가맹점 회원 id, 최대 100자 (실명, ID와 같은 개인정보가 포함되지 않도록 유의)
	private String item_name; // 상품명, 최대 100자
	private int quantity; // 상품 수량
	private int total_amount; // 상품 총액
	private int tax_free_amount; // 상품 비과세 금액
	private String approval_url; // 결제 성공 시 redirect url, 최대 255자
	private String cancel_url; // 결제 취소 시 redirect url, 최대 255자
	private String fail_url; // 결제 실패 시 redirect url, 최대 255자
	
	public String getCid() {
		return cid;
	}
	public void setCid(String cid) {
		this.cid = cid;
	}
	public String getPartner_order_id() {
		return partner_order_id;
	}
	public void setPartner_order_id(String partner_order_id) {
		this.partner_order_id = partner_order_id;
	}
	public String getPartner_user_id() {
		return partner_user_id;
	}
	public void setPartner_user_id(String partner_user_id) {
		this.partner_user_id = partner_user_id;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}

	public int getQuantity() {
		return quantity;
	}
	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}
	public int getTotal_amount() {
		return total_amount;
	}
	public void setTotal_amount(int total_amount) {
		this.total_amount = total_amount;
	}
	public int getTax_free_amount() {
		return tax_free_amount;
	}
	public void setTax_free_amount(int tax_free_amount) {
		this.tax_free_amount = tax_free_amount;
	}
	public String getApproval_url() {
		return approval_url;
	}
	public void setApproval_url(String approval_url) {
		this.approval_url = approval_url;
	}
	public String getCancel_url() {
		return cancel_url;
	}
	public void setCancel_url(String cancel_url) {
		this.cancel_url = cancel_url;
	}
	public String getFail_url() {
		return fail_url;
	}
	public void setFail_url(String fail_url) {
		this.fail_url = fail_url;
	}
	
	@Override
	public String toString() {
		return "KakaoPayReadyReqVO [cid=" + cid + ", partner_order_id=" + partner_order_id + ", partner_user_id="
				+ partner_user_id + ", item_name=" + item_name + ", quantity=" + quantity + ", total_amount="
				+ total_amount + ", tax_free_amount=" + tax_free_amount + ", approval_url=" + approval_url
				+ ", cancel_url=" + cancel_url + ", fail_url=" + fail_url + "]";
	}
	
}
