package kr.or.ddit.dam.order.dao;

import java.util.List;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;import org.apache.jasper.JasperException;

import kr.or.ddit.dam.vo.GiftVO;
import kr.or.ddit.dam.vo.OrdersDetailVO;
import kr.or.ddit.dam.vo.OrdersVO;
import kr.or.ddit.dam.vo.PaymentVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class OrderDaoImpl implements IOrderDao {
	
	private static IOrderDao orderDao = new OrderDaoImpl();
	
	private OrderDaoImpl() {}
	
	public static IOrderDao getInstance() {
		return orderDao;
	}

	@Override
	public List<OrdersVO> getOrdersList(String cust_id) {
		List<OrdersVO> orderList = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			orderList = session.selectList("orders.getOrdersList", cust_id);
			
		} catch (PersistenceException ex) {
			
		} finally {
			session.close();
		}
		
		System.out.println("엥" + orderList);
		return orderList;
	}
	
	// 회원의 한 달 주문번호를 얻어오는 메소드 (등급 업데이트용)
	@Override
	public List<OrdersVO> getOrdersMonthlyList(String cust_id) {
		List<OrdersVO> odvList = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			odvList = session.selectList("orders.getOrdersMonthlyList", cust_id);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return odvList;
	}

	@Override
	public List<OrdersDetailVO> getOrdersDetailList(Long order_no) {
		List<OrdersDetailVO> odvo = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			odvo = session.selectList("orders.getOrdersDetailList", order_no);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return odvo;
	}

	@Override
	public List<GiftVO> getGiftList() {
		List<GiftVO> giftList = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			giftList = session.selectList("orders.getGiftList");
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return giftList;
	}
	
	@Override
	public GiftVO getGiftSelectInfo(int gift_no) {
		GiftVO gvo = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			gvo = session.selectOne("orders.getGiftSelectInfo", gift_no);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return gvo;
	}

	@Override
	public Long getOrderNo() {
		Long orderNo = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			orderNo = session.selectOne("orders.getOrderNo");
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return orderNo;
	}

	@Override
	public int insertPayment(PaymentVO paymentInfo) {
		int cnt = 0;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			cnt = session.insert("orders.insertPayment", paymentInfo);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.commit(); // 결제 후, 서블릿에서 커밋 예정이었으나 그러면 다른게 커밋이 안됨..
			session.close();
		}
		
		return cnt;
	}

}
