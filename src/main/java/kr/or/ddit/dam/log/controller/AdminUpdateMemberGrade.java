package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.vo.CustVO;
import java.io.IOException;
import java.time.LocalDate;

import java.util.List;

/**
 * Servlet implementation class UpdateMemberGrade
 * @param <MemberGradeDTO>
 */
@WebServlet("/AdminUpdateMemberGrade.do")
public class AdminUpdateMemberGrade<MemberGradeDTO> extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminUpdateMemberGrade() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		 // 날짜 범위 (직전 1개월)
		LocalDate today = LocalDate.now();
        LocalDate startDate = today.minusMonths(1).withDayOfMonth(1); // 직전 월 1일
        LocalDate endDate = today.minusMonths(1).withDayOfMonth(today.minusMonths(1).lengthOfMonth()); // 직전 월 말일

        ICustService custService = CustServiceImpl.getService();

        try {
            // 회원 등급 갱신을 위한 구매액 조회
            List<CustVO> memberGrades = custService.getMemberGrades(startDate, endDate);

            if (memberGrades == null || memberGrades.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("No members to update.");
                return;
            }

            // 등급 갱신 시작
            for (CustVO member : memberGrades) {
                double purePurchaseAmount = member.getTotal_amt(); // 순수 구매액

                // 구매 내역이 있는 회원만 등급을 갱신
                if (purePurchaseAmount > 0) {
                    String mem_grade = determineGrade(purePurchaseAmount); // 등급 결정
                    if (!custService.updateMemberGrade(member.getCust_id(), mem_grade)) {
                        throw new Exception("회원 등급 업데이트 실패: " + member.getCust_id());
                    }
                }
            }

            // 갱신 후 클라이언트에게 버튼 활성화 신호 전송
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("success");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("failure: " + e.getMessage());
        }
    }

    private String determineGrade(double purePurchaseAmount) {
        if (purePurchaseAmount >= 200000) {
            return "다이아몬드등급";
        } else if (purePurchaseAmount >= 150000) {
            return "골드등급";
        } else if (purePurchaseAmount >= 50000) {
            return "실버등급";
        } else {
            return "일반등급";
        }
    }
}