package kr.or.ddit.dam.orderManage.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.orderManage.dao.IOrderManageDao;
import kr.or.ddit.dam.orderManage.dao.OrderManageDaoImpl;
import kr.or.ddit.dam.vo.OrderManageVO;

public class OrderManageServiceImpl implements IOrderManageService{

	private static IOrderManageService service;
	private IOrderManageDao dao;
	
	private OrderManageServiceImpl() {
		dao = OrderManageDaoImpl.getInstance();
	}
	
	public static IOrderManageService getService() {
		if(service == null) service = new OrderManageServiceImpl();
		return service;
	}
	
	@Override
	public List<OrderManageVO> getOrderList(Map<String, Object> map) {
		return dao.selectOrderManageList(map);
	}
	
    @Override
    public int getOrderCount(Map<String, Object> map) {
        return dao.selectOrderManageCount(map);
    }

	@Override
	public int changeOrderStatus(Map<String, Object> map) {
		return dao.updateOrderStatus(map);
	}

	/*
	 * @Override public boolean checkRefundExists(String orderNo) { return
	 * dao.checkRefundExists(orderNo); }
	 * 
	 * @Override public int updateRefundCompleteDate(String orderNo) { return
	 * dao.updateRefundCompleteDate(orderNo); }
	 */

}
