package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cart.dao.CartDaoImpl;
import kr.or.ddit.dam.cart.dao.ICartDao;
import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.pay.dao.IPayDao;
import kr.or.ddit.dam.pay.dao.PayDaoImpl;
import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.MemVO;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet implementation class InsertCust
 */
@WebServlet("/InsertCust.do")
public class InsertCust extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public InsertCust() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		// 고객 정보
        String mail = request.getParameter("mem_mail");
        String name = request.getParameter("cust_name");
        String zip = request.getParameter("cust_zip");
        String addr1 = request.getParameter("cust_addr1");
        String addr2 = request.getParameter("cust_addr2");
        String tel = request.getParameter("cust_tel");

        // 멤버 정보
        String pass = request.getParameter("mem_pass");
        String birStr = request.getParameter("mem_bir");
        String nickname = request.getParameter("mem_nickname");
        String gender = request.getParameter("mem_gender");
        String grade = request.getParameter("mem_grade");

        // CustVO 세팅
        CustVO cvo = new CustVO();
        cvo.setCust_id(mail);
        cvo.setCust_name(name);
        cvo.setCust_zip(zip);
        cvo.setCust_addr1(addr1);
        cvo.setCust_addr2(addr2);
        cvo.setCust_tel(tel);

        // MemVO 세팅
        MemVO mvo = new MemVO();
        mvo.setMem_mail(mail);
        mvo.setMem_pass(pass != null ? pass : "defaultPass");

        int bir = 0;
        try {
            bir = Integer.parseInt(birStr);
        } catch (Exception e) {
            bir = 0;
        }

        mvo.setMem_bir(bir);
        mvo.setMem_nickname(nickname != null ? nickname : "guest");
        mvo.setMem_gender(gender);
        mvo.setMem_grade(grade != null ? grade : "일반등급");
        mvo.setMem_join(new java.sql.Date(System.currentTimeMillis()));
        mvo.setMem_resign("N");
        mvo.setMem_mileage(0);

        System.out.println("받은 정보: " + mail + " " + name + " " + zip + " " + addr1 + " " + addr2 + " " + tel);

        ICustService cService = CustServiceImpl.getService();
        IMemService mService = MemServiceImpl.getService();
        ICartDao cartDao = CartDaoImpl.getInstance();
        

        int cres = 0;
        try {
            cres = cService.insertCust(cvo);
            
        } catch (Exception e) {
            String errorMsg = e.getMessage();
            System.out.println("고객 등록 중 오류: " + errorMsg);

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"flag\":\"" + errorMsg + "\"}");
            return;
        }

        CustVO cvo21 = cService.getCustId(mail);
        if (cvo21 != null) {
            System.out.println("getCustId 결과: " + cvo21.getCust_id());
        } else {
            System.out.println("getCustId 반환값이 null입니다.");
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"flag\":\"고객 정보 조회 실패\"}");
            return;
        }

        int mres = 0;
        if (cres > 0) {
            mres = mService.insertMember(mvo);
            
            /////////// 회원 가입 후, Mileage 테이블에 데이터를 삽입하는 로직 (가영) ////////////
      		Map<String, Object> memMap = new HashMap<String, Object>(); 
      		memMap.put("mem_mail", mail);
      		memMap.put("mileage_type", "회원가입");
      		memMap.put("total_mileage", 1000);
      		
      		IPayDao payDao = PayDaoImpl.getInstance();
      		payDao.insertMileage(null, memMap);
      		//////////////////////////////////////////////////////////////////////
        }

        String msg = "";
        if (cres > 0 && mres > 0) {
            msg = "고객 등록 성공";
            cartDao.insertCartNo(mail); // 기본 장바구니 생성
        } else {
            msg = "고객 등록 실패";
        }
        request.setAttribute("msg", msg); 

        System.out.println("결과: " + msg);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write("{\"flag\":\"" + msg + "\"}");
    }
}