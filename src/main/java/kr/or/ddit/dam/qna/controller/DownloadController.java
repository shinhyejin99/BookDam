package kr.or.ddit.dam.qna.controller;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URLEncoder;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import kr.or.ddit.dam.qna.service.AtchFileServiceImpl;
import kr.or.ddit.dam.qna.service.IAtchFileService;
import kr.or.ddit.dam.vo.AtchFileDetailVO;

@WebServlet("/qna/download.do")
public class DownloadController extends HttpServlet{

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String FileId = req.getParameter("atchFileId");
		String fileSn = req.getParameter("fileSn");
		
		IAtchFileService fileService = AtchFileServiceImpl.getInstance();
		AtchFileDetailVO detailVO = new AtchFileDetailVO();
		detailVO.setAtchFileId(Long.parseLong(FileId));
		detailVO.setFileSn(Integer.parseInt(fileSn));
		detailVO = fileService.getAtchFileDetail(detailVO);
			
		/*
		 	Content-Disposition 헤더에 대하여.. (파일 다운로드 처리하는 경우)
		 	
		 	Content-Disposition: inline(default)
		 	Content-Disposition: attachment
		 	Content-Disposition: attachment; filename="abc.jpg" //해당이름으로 다운로드 처리하기
		 */
        String filePath = detailVO.getFileStreCours();
        System.out.println("파일 경로: " + detailVO.getFileStreCours());
        
        //1. 파일 존재 확인
        File file = new File(filePath);
        if (!file.exists()) {
            resp.setContentType("text/html; charset=UTF-8");
            resp.getWriter().println("<script>alert('파일이 존재하지 않습니다.'); history.back();</script>");
            return;
        }

        
		//파일 다운로드 처리를 위한 응답헤더 정보 설정하기
		resp.setContentType("application/octet-stream"); //binary data
		
		/*
		 * URLEncoding을 이용하여 인코딩 작업을 하면 공백은 (+)로 표시되기 때문에
		 * + 문자를 공백을 의미하는 %20으로 바꾸어 주어야한다
		 */
		resp.setHeader("Content-Disposition", "attachment; filename=\""+ URLEncoder.encode(detailVO.getOrignlFileNm(), "UTF-8").replaceAll("\\+", "%20")  +"\" ");
		
		
		
		//BufferedInputStream bis = new BufferedInputStream(new FileInputStream(detailVO.getFileStreCours()));
		//BufferedOutputStream bos = new BufferedOutputStream(resp.getOutputStream());
		
		BufferedInputStream bis = new BufferedInputStream(new FileInputStream(filePath));
		BufferedOutputStream bos = new BufferedOutputStream(resp.getOutputStream());
		
		int data = 0;
		while((data=bis.read()) != -1) {
			bos.write(data);
		}
		bis.close();
		bos.close();
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doGet(req, resp);
	}
}
