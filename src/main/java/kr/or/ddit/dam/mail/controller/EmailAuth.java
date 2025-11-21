package kr.or.ddit.dam.mail.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/emailAuth")
public class EmailAuth extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Gmail 계정과 앱 비밀번호 (앱 비밀번호 권장)
    private final String SENDER_EMAIL = "email";
    private final String SENDER_PASSWORD = "SECRET_KEY";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 클라이언트가 요청한 action 파라미터를 확인 (sendCode or verifyCode)
        String action = request.getParameter("action");

        // JSON 응답을 위해 컨텐츠 타입을 설정
        response.setContentType("application/json;charset=UTF-8");

        if ("sendCode".equals(action)) {
            sendAuthCode(request, response); // 인증 코드 발송
        } else if ("verifyCode".equals(action)) {
            verifyAuthCode(request, response); // 인증 코드 검증
        } else {
            // 유효하지 않은 action 요청 시 에러 메시지 JSON 반환
            response.getWriter().write("{\"success\":false,\"msg\":\"Invalid action\"}");
        }
    }

    // 인증 코드 이메일 전송 처리 메서드
    private void sendAuthCode(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String userEmail = request.getParameter("userEmail"); // 클라이언트가 보낸 이메일 주소
        HttpSession session = request.getSession();

        // 이메일 입력이 없으면 에러 메시지 응답
        if (userEmail == null || userEmail.trim().isEmpty()) {
            response.getWriter().write("{\"success\":false,\"msg\":\"이메일을 입력하세요.\"}");
            return;
        }

        // 이메일 발송용 클래스 생성
        EmailSender emailSender = new EmailSender(SENDER_EMAIL, SENDER_PASSWORD);
        // 6자리 랜덤 인증 코드 생성
        String authCode = emailSender.generateAuthCode();

        // 세션에 인증 코드와 인증 대상 이메일 저장 (추후 검증용)
        session.setAttribute("authCode", authCode);
        session.setAttribute("userEmailForAuth", userEmail);

        // 이메일 제목과 내용 작성
        String subject = "[BookDam] 안녕하세요 BookDam 입니다. 이메일 인증 코드 알려드립니다.";
        String content = "BookDam 이용해주셔서 감사합니다." + "\n인증 코드: " + authCode + "\n이 코드를 입력하여 인증을 완료해주세요.";

        // 실제 이메일 발송 시도
        boolean emailSent = emailSender.sendEmail(userEmail, subject, content);

        // 이메일 발송 성공 여부에 따라 JSON 응답 반환
        if (emailSent) {
            response.getWriter().write("{\"success\":true,\"msg\":\"인증 코드가 전송되었습니다.\"}");
        } else {
            response.getWriter().write("{\"success\":false,\"msg\":\"이메일 전송에 실패했습니다.\"}");
        }
    }

    // 클라이언트가 입력한 인증 코드 검증 메서드
    private void verifyAuthCode(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String enteredCode = request.getParameter("authCode"); // 클라이언트가 입력한 코드
        HttpSession session = request.getSession();

        // 세션에 저장된 원래 인증 코드와 이메일 불러오기
        String storedCode = (String) session.getAttribute("authCode");
        String userEmailForAuth = (String) session.getAttribute("userEmailForAuth");

        // 인증 실패 조건 검사 (코드가 없거나 일치하지 않을 때)
        if (enteredCode == null || storedCode == null || !enteredCode.equals(storedCode)) {
            response.getWriter().write("{\"success\":false,\"msg\":\"인증 코드가 일치하지 않습니다.\"}");
        } else {
            // 인증 성공 시 세션에 저장된 정보 삭제 (재사용 방지)
            session.removeAttribute("authCode");
            session.removeAttribute("userEmailForAuth");

            // 인증 성공 메시지 JSON 반환
            response.getWriter().write("{\"success\":true,\"msg\":\"인증이 완료되었습니다.\"}");
        }
    }
}