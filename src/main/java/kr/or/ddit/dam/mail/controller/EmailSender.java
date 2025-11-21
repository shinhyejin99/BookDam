package kr.or.ddit.dam.mail.controller;

import java.util.Properties;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailSender {
    private final String senderEmail;       // 발신자 이메일
    private final String senderPassword;    // 발신자 앱 비밀번호

    // 생성자: 발신자 이메일과 비밀번호를 받아 저장
    public EmailSender(String senderEmail, String senderPassword) {
        this.senderEmail = senderEmail;
        this.senderPassword = senderPassword;
    }

    // 이메일을 실제로 보내는 메서드
    public boolean sendEmail(String toEmail, String subject, String content) {
        // Gmail SMTP 서버 설정
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");         // Gmail SMTP 서버
        props.put("mail.smtp.port", "587");                    // TLS 포트 번호
        props.put("mail.smtp.auth", "true");                   // 인증 필요
        props.put("mail.smtp.starttls.enable", "true");        // TLS 사용

        // 인증 정보를 담은 세션 생성
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(senderEmail, senderPassword);
            }
        });

        try {
            // 이메일 메시지 객체 생성 및 기본 설정
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(senderEmail));           // 발신자 설정
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail)); // 수신자 설정
            message.setSubject(subject);                                  // 제목 설정
            message.setText(content);                                     // 본문 텍스트 설정

            // 이메일 전송
            Transport.send(message);
            return true;  // 성공 시 true 반환
        } catch (MessagingException e) {
            e.printStackTrace();
            return false; // 실패 시 false 반환
        }
    }

    // 인증 코드 생성 메서드 (6자리 숫자)
    public String generateAuthCode() {
        int code = (int)(Math.random() * 900000) + 100000; // 100000~999999 난수 생성
        return String.valueOf(code);
    }
}