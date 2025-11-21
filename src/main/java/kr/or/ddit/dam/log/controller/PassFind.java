package kr.or.ddit.dam.log.controller;

import java.io.IOException;
import java.io.PrintWriter;

import com.google.gson.JsonObject;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;

/**
 * Servlet implementation class PassFind
 */
@WebServlet("/PassFind.do")
public class PassFind extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String mail = request.getParameter("mem_mail");
        String bir = request.getParameter("mem_bir");

        System.out.println("[PassFind.do] 요청됨 → mail=" + mail + ", bir=" + bir);

        IMemService service = MemServiceImpl.getService();

        // 임시비번 발급 + DB저장 + 화면 표시용 비번 반환
        String tempPass = service.processPassFind(mail, bir);

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        if (tempPass != null) {
            out.write("{\"pass\":\"" + tempPass + "\"}");
        } else {
            out.write("{}");
        }

        out.flush();
    }
}
