package kr.or.ddit.dam.order.dao;

import java.util.List;

import kr.or.ddit.dam.vo.GiftVO;
import kr.or.ddit.dam.vo.OrdersDetailVO;
import kr.or.ddit.dam.vo.OrdersVO;
import kr.or.ddit.dam.vo.PaymentVO;

public interface IOrderDao {
	
	/**
	 * 회원의 주문 번호를 얻어오는 메소드
	 * @param cust_id 회원 아이디
	 * @return 주문 정보(번호, 상태, 총 결제금액 등)를 담을 vo
	 */
	public List<OrdersVO> getOrdersList(String cust_id);
	
	/** 회원의 한 달 주문번호를 얻어오는 메소드 (등급 업데이트용)
	 * @param cust_id 회원 아이디
	 * @return 주문번호를 포함한 orders 테이블 정보
	 */
	public List<OrdersVO> getOrdersMonthlyList(String cust_id);
	
	/**
	 * 주문 번호의 상품 정보를 얻어오는 메소드
	 * @param order_no 주문 번호
	 * @return 상품 정보를 담을 vo
	 */
	public List<OrdersDetailVO> getOrdersDetailList(Long order_no);
	
	/**
	 * DB에서 사은품 정보를 전부 얻어오는 메소드
	 * @return
	 */
	public List<GiftVO> getGiftList();
	
	/**
	 * 사은품 번호에 따라 사은품 정보를 얻어오는 메소드
	 * @param gift_no 사은품 번호
	 * @return 해당하는 사은품 정보가 담긴 vo
	 */
	public GiftVO getGiftSelectInfo(int gift_no);
	
	/**
	 * DB에서 주문 번호를 얻어오는 메소드
	 * @return
	 */
	public Long getOrderNo();
	
	/**
	 * 결제 후 결제 정보를 저장하는 메소드
	 * @param paymentInfo 주문번호, 결제 금액, 사용한 마일리지를 담은 메소드
	 * @return
	 */
	public int insertPayment(PaymentVO paymentInfo);
	
}
