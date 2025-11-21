package kr.or.ddit.dam.log.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import kr.or.ddit.dam.admin.service.AdminServiceImpl;
import kr.or.ddit.dam.admin.service.IAdminService;
import kr.or.ddit.dam.cust.service.CustServiceImpl;
import kr.or.ddit.dam.cust.service.ICustService;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.vo.AdminVO;
import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.dam.util.StreamData;

import java.io.IOException;
import java.io.PrintWriter;

import com.google.gson.Gson;
import com.google.gson.JsonObject;

@WebServlet("/Login.do")
public class Login extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String reqData = StreamData.getChange(request);
        Gson gson = new Gson();
        JsonObject reqJson = gson.fromJson(reqData, JsonObject.class);

        response.setContentType("application/json;charset=utf-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();

        IAdminService adminservice = AdminServiceImpl.getService();
        IMemService memservice = MemServiceImpl.getService();
        ICustService custservice = CustServiceImpl.getService();

        System.out.println("요청 JSON: " + reqData);

        /* ----------------------- 관리자 로그인 -------------------------- */
        if (reqJson.has("admin_id") && reqJson.has("admin_pass")) {

            String adminId = reqJson.get("admin_id").getAsString();
            String adminPass = reqJson.get("admin_pass").getAsString();

            System.out.println("관리자 로그인 시도: ID=" + adminId + ", PASS=" + adminPass);

            AdminVO admin = adminservice.loginAdmin(adminId, adminPass);

            if (admin != null) {
                json.addProperty("flag", "ok");
                json.addProperty("role", "admin");
                json.addProperty("admin_id", admin.getAdmin_id());

                request.getSession().setAttribute("loginAdmin", admin);
                System.out.println("관리자 로그인 성공");
            } else {
                json.addProperty("flag", "fail");
                json.addProperty("message", "입력하신 관리자 정보가 일치하지 않습니다.");
                System.out.println("관리자 로그인 실패");
            }
        }

        /* ----------------------- 회원 로그인 --------------------------- */
        else if (reqJson.has("mem_mail") && reqJson.has("mem_pass")) {

            String memMail = reqJson.get("mem_mail").getAsString();
            String memPass = reqJson.get("mem_pass").getAsString();

            System.out.println("회원 로그인 시도: MAIL=" + memMail + ", PASS=" + memPass);

            // ✔ 입력 비밀번호를 SHA-256 으로 암호화
            String encPass = memservice.encryptSHA256(memPass);

            MemVO mvo = new MemVO();
            mvo.setMem_mail(memMail);
            mvo.setMem_pass(encPass);

            MemVO mvo1 = memservice.loginMember(mvo);

            if (mvo1 != null) {

                String memResignStatus = mvo1.getMem_resign();

                if ("Y".equals(memResignStatus)) {
                    json.addProperty("flag", "fail");
                    json.addProperty("message", "탈퇴된 계정입니다. 다시 확인해 주세요.");
                    System.out.println("탈퇴된 계정으로 로그인 시도");

                } else {
                    json.addProperty("flag", "ok");
                    json.addProperty("role", "member");
                    json.addProperty("mem_id", mvo1.getMem_mail());

                    request.getSession().setAttribute("loginOk", mvo1);

                    CustVO cvo = custservice.getCustById(mvo1.getMem_mail());
                    if (cvo != null) {
                        request.getSession().setAttribute("loginCust", cvo);
                    }

                    System.out.println("회원 로그인 성공");
                }

            } else {
                json.addProperty("flag", "fail");
                json.addProperty("message", "입력하신 회원 정보가 일치하지 않습니다.");
            }
        }

        // 응답 전송
        out.print(json.toString());
        out.flush();
    }
}
