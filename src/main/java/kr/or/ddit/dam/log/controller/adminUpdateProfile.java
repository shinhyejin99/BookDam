package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;

import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.MemVO;

import java.io.IOException;


/**
 * Servlet implementation class UpdateProfile
 */
@WebServlet("/AdminUpdateProfile.do")

public class adminUpdateProfile extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public adminUpdateProfile() {
        super();
        // TODO Auto-generated constructor stub
    }

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
				// 3. 클라이언트가 보낸 폼 데이터(request parameter) 받기
				//    특히, 수정할 회원의 이메일 주소(mem_mail)를 파라미터로 받아야 합니다.
				String mem_mail = request.getParameter("mem_mail"); // JSP 모달 폼에서 이메일을 받아옴
				String pass = request.getParameter("mem_pass");
				String nickname = request.getParameter("mem_nickname");
				String tel = request.getParameter("cust_tel");
				String zip = request.getParameter("cust_zip");
				String addr1 = request.getParameter("cust_addr1");
				String addr2 = request.getParameter("cust_addr2");
				String gender = request.getParameter("cust_gender"); // 성별 추가 (JSP 모달 폼에 cust_gender로 되어있음)

				System.out.println("adminUpdateProfile : " + mem_mail + pass + nickname + tel + zip + addr1 + addr2 + gender);
				
				// 필수 파라미터 체크 (mem_mail이 없으면 오류)
				if (mem_mail == null || mem_mail.trim().isEmpty()) {
				    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
				    response.setContentType("application/json; charset=UTF-8");
				    response.getWriter().write("{\"result\":\"fail\", \"message\":\"수정할 회원 이메일(mem_mail)이 필요합니다.\"}");
				    return;
				}

				// 4. MemVO와 CustVO 객체 세팅
				// MemVO에 멤버 정보 세팅
				MemVO mvo = new MemVO();
				mvo.setMem_mail(mem_mail); // 수정할 회원의 이메일로 설정
				mvo.setMem_pass(pass);
				mvo.setMem_nickname(nickname);
				mvo.setMem_gender(gender != null && gender.equals("남성") ? "M" : (gender != null && gender.equals("여성") ? "F" : null)); // 성별 M/F로 변환

				// CustVO에 고객 정보 세팅
				CustVO cvo = new CustVO();
				cvo.setCust_id(mem_mail); // 수정할 회원의 이메일로 설정
				cvo.setCust_tel(tel);
				cvo.setCust_zip(zip);
				cvo.setCust_addr1(addr1);
				cvo.setCust_addr2(addr2);

				// 5. 서비스 객체 얻기
				IMemService memService = MemServiceImpl.getService();
				ICustService custService = CustServiceImpl.getService();

				// 6. 서비스 메서드 호출하여 DB 업데이트 수행
				int memUpdateResult = memService.updateMember(mvo); // 멤버 정보 수정
				int custUpdateResult = custService.updateCust(cvo); // 고객 정보 수정

				// 7. 응답으로 JSON 타입 지정 (UTF-8 인코딩)
				response.setContentType("application/json; charset=UTF-8");

				// 8. 두 업데이트 모두 성공했으면 성공 메시지, 아니면 실패 메시지 반환
				if (memUpdateResult > 0 && custUpdateResult > 0) {
		            response.getWriter().write("{\"result\":\"success\"}");
		            
		            // PRG 적용: 처리 후 성공 페이지로 리디렉션
		            response.sendRedirect(request.getContextPath() + "/admin/adminMain.jsp"); // 예시로 관리 페이지로 리디렉션
		        } else {
		            response.getWriter().write("{\"result\":\"fail\", \"message\":\"회원 정보 수정 실패.\"}");
		        }
		    }
		}