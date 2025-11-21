package kr.or.ddit.dam.cart.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.BookVO;
import kr.or.ddit.dam.vo.CartDetailVO;
import kr.or.ddit.dam.vo.CartItemVO;
import kr.or.ddit.dam.vo.DelCartVO;
import kr.or.ddit.dam.vo.DeliveryVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class CartDaoImpl implements ICartDao {
	
	// 싱글톤
	private static ICartDao cartDao = new CartDaoImpl();
	
	// 싱글톤
	private CartDaoImpl() {};
	
	// 싱글톤
	public static ICartDao getInstance() {
		return cartDao;
	}

	// 로그인한 회원의 cust_no를 가져오는 메소드
	@Override
	public int getCartBook(Map<String, Object> cartMap) {
		
		int cnt = 0;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			cnt = session.selectOne("cart.getCartBook", cartMap);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return cnt;
	}
	
	
	// 로그인한 cust_id를 가지고 카트 리스트를 가져오는 메소드
	@Override
	public List<CartItemVO> getCartList(String cust_id) {

		List<CartItemVO> cartList = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			cartList = session.selectList("cart.getCartList", cust_id);
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return cartList;
	}

	// 로그인한 cust_id를 가지고 배송 정보를 가져와는 메소드
	@Override
	public DeliveryVO getDeliveryInfo(String cust_id) {
		DeliveryVO deliveryInfo = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			deliveryInfo = session.selectOne("cart.getDeliveryInfo", cust_id);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return deliveryInfo;
	}

	// 선택한 장바구니 상품을 삭제하는 메소드 (결제 후처리)
	@Override
	public int deleteCartDetail(SqlSession sqlSession, Map<String, Object> cartMap) {
		int cnt = 0;
		
		try {
			cnt = sqlSession.delete("cart.deleteCartDetail", cartMap);
				
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			// session.commit(); 결제 후처리 후 서블릿에서 commit, close
			// session.close();
		}
		
		return cnt;
	}
	
	// 선택한 장바구니 상품을 삭제하는 메소드 (장바구니)
	@Override
	public int delCart(DelCartVO delCartVO) {
		int cnt = 0;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			for (CartItemVO item : delCartVO.getBook_no()) {
				Map<String, Object> paramMap = new HashMap<String, Object>();
				
				paramMap.put("cust_id", delCartVO.getCust_id());
				paramMap.put("book_no", item.getBook_no());
				
				cnt += session.delete("cart.delCart", paramMap);
			}
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.commit();
			session.close();
		}
		
		return cnt;
	}

	@Override
	public BookVO getBookInfo(Long book_no) {
		BookVO book = null;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			book = session.selectOne("book.getBookDetail", book_no);
		} catch(PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.close();
		}
		
		return book;
	}

	@Override
	public int updateCartQty(String btnType, CartDetailVO dvo) {
		int cnt = 0;
		
		SqlSession session = MybatisUtil.getInstance();
		
		try {
			if (btnType.equals("0")) {
				cnt = session.update("cart.updateMinusQty", dvo);
			} else {
				cnt = session.update("cart.updatePlusQty", dvo);
			}
			
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.commit();
			session.close();
		}
		
		return cnt;
	}

	// 카트에 상품을 추가하는 메서드
	@Override
	public int insertCart(CartDetailVO cartItem) {
		SqlSession session = MybatisUtil.getInstance();
		
		int cnt = 0;
		
		try {
			cnt = session.insert("cart.insertCart", cartItem);
		} catch (PersistenceException ex) {
			ex.printStackTrace();
		} finally {
			session.commit();
			session.close();
		}
		
		return cnt;
	}

	// 고객아이디에 장바구니 번호 생성
	@Override
	public int insertCartNo(String cust_id) {
		
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;

		try {
			res = session.insert("cart.insertCartNo", cust_id);
			if (res > 0) session.commit();
		} catch (Exception e) {
			e.printStackTrace();
			session.rollback();
		} finally {
			if (session != null) session.close();
		}

		return res;
		
	}
}
