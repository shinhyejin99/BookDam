package kr.or.ddit.dam.cart.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.CartDetailVO;
import kr.or.ddit.dam.vo.CartItemVO;
import kr.or.ddit.dam.vo.DelCartVO;
import kr.or.ddit.dam.vo.DeliveryVO;

public interface ICartDao {
	
	/**
	 * 회원의 장바구니에 해당 도서가 들어있는지 확인하는 메소드
	 * @param cartMap 회원 아이디와 도서 번호를 담은 Map
	 * @return 있으면 1, 없으면 0
	 */
	public int getCartBook(Map<String, Object> cartMap);
	
	/**
	 *  카트 리스트를 가져오는 메소드
	 * @param cust_id 로그인한 회원
	 * @return 카트 리스트
	 */
	public List<CartItemVO> getCartList(String cust_id);
	
	/**
	 * 배송 정보를 가져오는 메소드
	 * @param cust_id 로그인한 회원
	 * @return customer 테이블 정보와 마일리지를 가져와는 메소드
	 */
	public DeliveryVO getDeliveryInfo(String cust_id);
	
	/**
	 * 선택한 장바구니 상품을 삭제하는 메소드
	 * @param cartMap cust_id와 삭제할 book_no를 담은 리스트 Map
	 * @return 성공하면 1, 실패하면 0
	 */
	public int deleteCartDetail(SqlSession sqlSession, Map<String, Object> cartMap);
	
	/**
	 * 선택한 장바구니 상품을 삭제하는 메소드
	 * @param delCart cust_id와 삭제할 book_no를 담은 리스트 VO
	 * @return 성공하면 1, 실패하면 0
	 */
	public int delCart(DelCartVO delCart);
	
	/**
	 * 도서 정보를 가져오는 메소드
	 * @param book_no 도서 번호
	 * @return 도서 정보 리스트
	 */
	public BookVO getBookInfo(Long book_no);
	
	/**
	 * 장바구니 수량을 업데이트 하는 메소드
	 * @param btnType 마이너스, 플러스 버튼 타입
	 * @param dvo 수량을 변경할 도서 정보를 담은 객체
	 * @return 성공하면 1, 실패하면 0
	 */
	public int updateCartQty(String btnType, CartDetailVO dvo);	
	
	/**
	 * 장바구니에 상품을 담는 메소드
	 * @param cartItem 장바구니에 담을 도서 번호와 수량을 담은 객체
	 * @return 성공하면 1, 실패하면 0
	 */
	public int insertCart(CartDetailVO cartItem);
	
	/**
	 * 
	 * @param cust_id 고객아이디에 장바구니 번호 생성
	 * @return
	 */
	public int insertCartNo(String cust_id);
}
