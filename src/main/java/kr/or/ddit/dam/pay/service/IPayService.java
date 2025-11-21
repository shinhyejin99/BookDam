package kr.or.ddit.dam.pay.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.OrdersDetailVO;
import kr.or.ddit.dam.vo.OrdersVO;
import kr.or.ddit.dam.vo.PaymentVO;
import kr.or.ddit.dam.vo.RefundVO;

public interface IPayService {
	
	
	/**
	 * 회원 등급을 가져오는 메소드
	 * @param mem_mail 회원 아이디
	 * @return 회원 등급 ('일반회원', '실버' 등)
	 */
	public String getMemGrade(String mem_mail);
	
	/**
	 * 결제 후 생성된 tid를 받아오는 메소드
	 * @param order_no tid를 찾아오기 위한 주문번호
	 * @return tid
	 */
	public String getTid(Long order_no);
	
	/**
	 * 결제정보를 가져오는 메소드
	 * @param orders 주문번호(payment 테이블에서는 payment_no)
	 * @return payment 정보를 담은 VO
	 */
	public PaymentVO getPaymentInfo(Long order_no);
	
	/**
	 * OrderDetail 테이블에 주문한 상품을 insert
	 * @param orderItem 주문번호, 주문상품, 수량이 들어가있는 VO
	 * @return 성공하면 1, 실패하면 0
	 */
	public int insertOrderDetail(OrdersDetailVO orderItem);
	
	/**
	 * GiftCheck 테이블에 선택한 사은품을 insert
	 * @param giftMap 주문번호와 사은품을 담은 Map
	 * @return 성공하면 1, 실패하면 0
	 */
	public int insertGiftCheck(SqlSession sqlSession, Map<String, Object> giftMap);
	
	/**
	 * OrderAddr 테이블에 배송지 정보 insert
	 * @param delivery_info 배송지 정보를 담은 CustVO
	 * @return 성공하면 1, 실패하면 0
	 */
	public int insertOrderAddr(SqlSession sqlSession, CustVO delivery_info);
	
	/**
	 * Mileage 테이블에 적립 내역 insert, Member 테이블에 마일리지 Update
	 * @param mileageMap 회원 아이디와 총 적립 마일리지를 담은 Map
	 * @return
	 */
	public int insertMileage(SqlSession sqlSession, Map<String, Object> mileageMap);
	
	/**
	 * 도서별로 적립 받았던 마일리지를 얻어오는 메소드
	 * @param order_no 주문번호
	 * @return 적립 받았던 마일리지 list
	 */
	public List<Integer> getMileList(Long order_no);
	
	/**
	 * Refund 테이블에 insert
	 * @param rvo 환불 정보를 담은 vo
	 * @return 성공하면 1, 실패하면 0
	 */
	public int insertRefund(SqlSession sqlSession, RefundVO rvo);
	
	/**
	 * Refund 테이블에 주문번호가 있는지 확인하는 메소드
	 * @param odv 주문번호가 들어있는 vo
	 * @return count 값
	 */
	public int getCheckRefund(OrdersVO odv);	
}
