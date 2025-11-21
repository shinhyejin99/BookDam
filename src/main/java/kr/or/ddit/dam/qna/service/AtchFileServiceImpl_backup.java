package kr.or.ddit.dam.qna.service;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.UUID;

import jakarta.security.auth.message.callback.PrivateKeyCallback.Request;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import kr.or.ddit.dam.qna.dao.AtchFileDaoImpl;
import kr.or.ddit.dam.qna.dao.IAtchFileDao;
import kr.or.ddit.dam.vo.AtchFileDetailVO;
import kr.or.ddit.dam.vo.AtchFileVO;

public class AtchFileServiceImpl_backup implements IAtchFileService{

	private static final String UPLOAD_DIR = "d:/D_Other/upload_files";
	
	private static IAtchFileService fileService = new AtchFileServiceImpl_backup();
	
	private IAtchFileDao fileDao;
	
	private AtchFileServiceImpl_backup() {
		fileDao = AtchFileDaoImpl.getInstance();
		
		File uploadDir = new File(UPLOAD_DIR);
		if(!uploadDir.exists()) {
			//없는경우 새로 만든다.
			uploadDir.mkdir();
		}
	}
	
	public static IAtchFileService getInstance() {
		return fileService;
	}
	
	@Override
	public AtchFileVO saveAtchFileList(Collection<Part> parts, int qnaQid, HttpServletRequest request) {
		AtchFileVO atchFileVO = null;
		
		boolean isFirstFile = true; //첫번째 업로드 파일여부
		
		//추가된부분
		String uploadPath = request.getServletContext().getRealPath("/upload");
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) uploadDir.mkdirs();
		
		for(Part part : parts) {
			String fileName = part.getSubmittedFileName();
			
			if(fileName != null && !fileName.equals("")) {
				//현재 Part는 첨부파일이 존재함
				if(isFirstFile) {
					isFirstFile = false;
					//atch_file 테이블에 데이터 저장하기
					atchFileVO = new AtchFileVO();  //atchFileVO안에 ID가 들어감
					atchFileVO.setQnaQid(qnaQid); // 추가한거 
					//AtchFileVO에 atchFileId가 저장된다
					int cnt = fileDao.insertAtchFile(atchFileVO);
				}
				String orignFileName = fileName; //원본파일명
				long fileSize = part.getSize(); //파일크기(사이즈) byte단위
				String saveFileName = UUID.randomUUID().toString().replace("-",""); 
				//String saveFilePath = UPLOAD_DIR + "/" + saveFileName;
				String saveFilePath = uploadPath + File.separator + saveFileName;
				//파일확장자 추출
				String fileExt = orignFileName.lastIndexOf(".") < 0 ?
						"" : orignFileName.substring(orignFileName.lastIndexOf(".") + 1);
				
				//첨부파일 업로드 처리
				try {
					part.write(saveFilePath);
					
					AtchFileDetailVO detailVO = new AtchFileDetailVO();
					detailVO.setAtchFileId(atchFileVO.getAtchFileId());
					detailVO.setOrignlFileNm(orignFileName);
					detailVO.setStreFileNm(saveFileName);
					detailVO.setFileExtsn(fileExt);
					detailVO.setFileStreCours(saveFilePath); //가장 중요한 정보
					detailVO.setFileSize(fileSize);
					detailVO.setFileCn("꽃 이미지 파일임");
					
					//atch_file_detail 테이블에 저장하기
					fileDao.insertAtchFileDetail(detailVO);
					
					part.delete(); //임시 업로드 파일 삭제하기...
					
				} catch (IOException e) {
					e.printStackTrace();
				}
				
				
			}
		}
		
		return atchFileVO;
	}

	@Override
	public AtchFileVO getAtchFile(AtchFileVO atchFileVO) {
		return fileDao.getAtchFile(atchFileVO);
	}

	@Override
	public AtchFileDetailVO getAtchFileDetail(AtchFileDetailVO atchFileDetailVO) {
		return fileDao.getAtchFileDetail(atchFileDetailVO);
	}

	public static void main(String[] args) {
		System.out.println(UUID.randomUUID().toString().replace("-",""));
	}

	@Override
	public int updateQnaQidForAtchFile(int qnaQid, Long atchFileId) {
		return fileDao.updateQnaQidForAtchFile(qnaQid, atchFileId);
	}

	@Override
	public AtchFileVO getAtchFileByQnaQid(int qnaQid) {
		return fileDao.selectAtchFileByQnaQid(qnaQid);
	}

	@Override
	public AtchFileVO saveAtchFileList(Collection<Part> parts, int qnaQid) {
		// TODO Auto-generated method stub
		return null;
	}
}
