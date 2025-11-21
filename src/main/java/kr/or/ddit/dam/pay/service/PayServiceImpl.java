package kr.or.ddit.dam.pay.service;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.pay.dao.IPayDao;
import kr.or.ddit.dam.pay.dao.PayDaoImpl;
import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.OrdersDetailVO;
import kr.or.ddit.dam.vo.OrdersVO;
import kr.or.ddit.dam.vo.PaymentVO;
import kr.or.ddit.dam.vo.RefundVO;

public class PayServiceImpl implements IPayService {
	// 싱글톤
	private static IPayService payService = new PayServiceImpl();
	
	private static IPayDao payDao;
	
	// 싱글톤
	private PayServiceImpl() {};
	// 싱글톤
	public static IPayService getInstance() {
		payDao = PayDaoImpl.getInstance();
		
		return payService;
	}

	
	@Override
	public String getMemGrade(String mem_mail) {
		return payDao.getMemGrade(mem_mail);
	}
	
	@Override
	public String getTid(Long order_no) {
		return payDao.getTid(order_no);
	}
	
	@Override
	public PaymentVO getPaymentInfo(Long order_no) {
		return payDao.getPaymentInfo(order_no);
	}
	
	@Override
	public int insertOrderDetail(OrdersDetailVO orderItem) {
		return payDao.insertOrderDetail(orderItem);
	}
	
	@Override
	public int insertGiftCheck(SqlSession sqlSession, Map<String, Object> giftMap) {
		return payDao.insertGiftCheck(sqlSession, giftMap);
	}
	
	@Override
	public int insertOrderAddr(SqlSession sqlSession, CustVO delivery_info) {
		return payDao.insertOrderAddr(sqlSession, delivery_info);
	}
	
	@Override
	public int insertMileage(SqlSession sqlSession, Map<String, Object> mileageMap) {
		return payDao.insertMileage(sqlSession, mileageMap);
	}
	@Override
	public List<Integer> getMileList(Long order_no) {
		return payDao.getMileList(order_no);
	}
	@Override
	public int insertRefund(SqlSession sqlSession, RefundVO rvo) {
		return payDao.insertRefund(sqlSession, rvo);
	}
	// Refund 테이블에 주문번호가 있는지 확인하는 메소드
	@Override
	public int getCheckRefund(OrdersVO odv) {
		return payDao.getCheckRefund(odv);
	}
}
