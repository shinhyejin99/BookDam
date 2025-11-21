package kr.or.ddit.dam.orderManage.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.OrderManageVO;

public interface IOrderManageDao {
	
	List<OrderManageVO> selectOrderManageList(Map<String, Object> map);

    int selectOrderManageCount(Map<String, Object> map);

    int updateOrderStatus(Map<String, Object> map);

	/*
	 * boolean checkRefundExists(String orderNo);
	 * 
	 * int updateRefundCompleteDate(String orderNo);
	 */
}
