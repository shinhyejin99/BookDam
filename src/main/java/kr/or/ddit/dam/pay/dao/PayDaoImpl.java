package kr.or.ddit.dam.pay.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.OrdersDetailVO;
import kr.or.ddit.dam.vo.OrdersVO;
import kr.or.ddit.dam.vo.PaymentVO;
import kr.or.ddit.dam.vo.RefundVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class PayDaoImpl implements IPayDao {
	// 싱글톤
	private static IPayDao payDao = new PayDaoImpl();
	// 싱글톤
	private PayDaoImpl() {};
	// 싱글톤
	public static IPayDao getInstance() {
		return payDao;
	}

	
	@Override
	public String getMemGrade(String mem_mail) {
		String memGrade = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			memGrade = session.selectOne("pay.getMemGrade", mem_mail);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return memGrade;
	}
	
	@Override
	public String getTid(Long order_no) {
		String tid = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			tid = session.selectOne("pay.getTid", order_no);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return tid;
	}
	
	@Override
	public PaymentVO getPaymentInfo(Long order_no) {
		PaymentVO pvo = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			pvo = session.selectOne("pay.getPaymentInfo", order_no);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return pvo;
	}
	
	@Override
	public int insertOrderDetail(OrdersDetailVO orderItem) {
		int cnt = 0;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			cnt = session.insert("pay.insertOrderDetail", orderItem);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.commit();
			session.close();
		}
		
		return cnt;
	}
	
	
	@Override
	public int insertGiftCheck(SqlSession sqlSession, Map<String, Object> giftMap) {
		int cnt = 0;
		
		try {
			cnt = sqlSession.insert("insertGiftCheck", giftMap);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			// session.commit(); 결제 후처리 후 서블릿에서 commit, close
			// session.close();
		}
		
		return cnt;
	}
	@Override
	public int insertOrderAddr(SqlSession sqlSession, CustVO delivery_info) {
		int cnt = 0;
		
		try {
			cnt = sqlSession.insert("pay.insertOrderAddr", delivery_info);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			// session.commit(); 결제 후처리 후 서블릿에서 commit, close
			// session.close();
		}
		
		return cnt;
	}
	
	@Override
	public int insertMileage(SqlSession sqlSession, Map<String, Object> mileageMap) {
		SqlSession sqlSession2 = null;
		if (sqlSession == null) {
			sqlSession2 = MybatisUtil.getInstance();
		}
		int cnt = 0;
		
		try {
			if (sqlSession != null) {
				cnt = sqlSession.insert("pay.insertMileage", mileageMap);
			} else {
				cnt = sqlSession2.insert("pay.insertMileage", mileageMap);
			}
			
		} catch(PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			// session.commit(); 결제 후처리 후 서블릿에서 commit, close
			// sqlSession.close();
			if (sqlSession == null) {
				sqlSession2.commit();
				sqlSession2.close();
			}
		}
		
		return cnt;
	}
	@Override
	public List<Integer> getMileList(Long order_no) {
		List<Integer> earnedMileList = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			earnedMileList = session.selectList("pay.getMileList", order_no);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return earnedMileList;
	}
	@Override
	public int insertRefund(SqlSession sqlSession, RefundVO rvo) {
		int cnt = 0;

		try {
			cnt = sqlSession.insert("pay.insertRefund", rvo);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			// session.commit(); 결제 후처리 후 서블릿에서 commit, close
			// sqlSession.close();
		}
		
		return cnt;
	}
	
	// Refund 테이블에 주문번호가 있는지 확인하는 메소드
	@Override
	public int getCheckRefund(OrdersVO odv) {
		int refundCnt = 0;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			refundCnt = session.selectOne("pay.getCheckRefund", odv);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return refundCnt;
	}
}
