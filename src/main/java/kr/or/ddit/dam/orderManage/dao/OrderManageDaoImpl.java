package kr.or.ddit.dam.orderManage.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.OrderManageVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class OrderManageDaoImpl implements IOrderManageDao {

	private static IOrderManageDao dao;
	
	private OrderManageDaoImpl() {};
	
	public static IOrderManageDao getInstance() {
		if (dao == null) dao = new OrderManageDaoImpl();
		return dao;
	}

	@Override
	public List<OrderManageVO> selectOrderManageList(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		List<OrderManageVO> list = null;
		
		try {
			list = session.selectList("orderManage.selectOrderManageList", map);
		} catch (PersistenceException e) {
			e.printStackTrace();
		} finally {
			if(session != null) {
				session.close();
			}
		}
		return list;
	}

	@Override
	public int selectOrderManageCount(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		int cnt = 0;

		try {
			cnt = session.selectOne("orderManage.selectOrderManageCount", map);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.close();
			}
		}
		return cnt;
	}
	
	@Override
	public int updateOrderStatus(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		int cnt = 0;
		
		try {
			cnt = session.update("orderManage.updateOrderStatus", map);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (session != null) {
				session.commit();
				session.close();
			}
		}
		return cnt;
	}

	/*
	 * @Override public boolean checkRefundExists(String orderNo) { SqlSession
	 * session = MybatisUtil.getInstance(); boolean exists = false;
	 * 
	 * try { Integer cnt = session.selectOne("orderManage.checkRefundExists",
	 * orderNo); exists = cnt != null && cnt > 0; } catch (Exception e) {
	 * e.printStackTrace(); } finally { session.close(); } return exists; }
	 * 
	 * @Override public int updateRefundCompleteDate(String orderNo) { SqlSession
	 * session = MybatisUtil.getInstance(); int cnt = 0;
	 * 
	 * try { cnt = session.update("orderManage.updateRefundCompleteDate", orderNo);
	 * } catch (Exception e) { e.printStackTrace(); } finally { if (session != null)
	 * { session.commit(); session.close(); } } return cnt; }
	 */
}