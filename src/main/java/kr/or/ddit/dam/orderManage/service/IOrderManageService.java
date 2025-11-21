package kr.or.ddit.dam.orderManage.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.OrderManageVO;

public interface IOrderManageService {
	
	// 조건에 따라 주문 목록 조회 (페이징 포함)
	List<OrderManageVO> getOrderList(Map<String, Object>map);

	// 조건에 따라 전체 주문 수 조회
	int getOrderCount(Map<String, Object> map);
	
	// 주문 상태 변경
	int changeOrderStatus(Map<String, Object>map);
	
	// 환불 존재 여부 확인
	// boolean checkRefundExists(String orderNo);
	
	// 환불 완료일자 갱신
	// int updateRefundCompleteDate(String orderNo);
}
