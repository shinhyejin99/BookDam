package kr.or.ddit.dam.qna.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.AtchFileServiceImpl;
import kr.or.ddit.dam.qna.service.IAtchFileService;
import kr.or.ddit.dam.vo.AtchFileVO;

@MultipartConfig
@WebServlet("/upload_ajax.do")
public class FileUploadController extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		System.out.println("tempData : " + req.getParameter("tempData"));
		
		IAtchFileService fileService = AtchFileServiceImpl.getInstance();
		
		int qnaQid = Integer.parseInt(req.getParameter("qnaQid"));
		AtchFileVO atchFileVO = fileService.saveAtchFileList(req.getParts(), qnaQid);
		
		if(atchFileVO == null) {
			
		}else {
			
			atchFileVO = fileService.getAtchFile(atchFileVO);
			
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap.put("fileList", atchFileVO.getAtchFileDetailList());
			
			Gson gson = new Gson();
			
			PrintWriter out = resp.getWriter();
			out.print(gson.toJson(resultMap, Map.class));
		}
	}
}
