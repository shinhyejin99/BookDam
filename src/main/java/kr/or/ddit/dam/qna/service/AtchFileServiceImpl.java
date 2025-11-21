package kr.or.ddit.dam.qna.service;

import java.io.File;
import java.io.IOException;
import java.util.Collection;
import java.util.UUID;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import kr.or.ddit.dam.qna.dao.AtchFileDaoImpl;
import kr.or.ddit.dam.qna.dao.IAtchFileDao;
import kr.or.ddit.dam.vo.AtchFileDetailVO;
import kr.or.ddit.dam.vo.AtchFileVO;

public class AtchFileServiceImpl implements IAtchFileService{

	private static IAtchFileService fileService = new AtchFileServiceImpl();
    private IAtchFileDao fileDao;

    private AtchFileServiceImpl() {
        fileDao = AtchFileDaoImpl.getInstance();
    }

    public static IAtchFileService getInstance() {
        return fileService;
    }

    @Override
    public AtchFileVO saveAtchFileList(Collection<Part> parts, int qnaQid, HttpServletRequest request) {
        AtchFileVO atchFileVO = null;
        boolean isFirstFile = true;

        String uploadPath = request.getServletContext().getRealPath("/upload");
        System.out.println("uploadPath = " + uploadPath);
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        for (Part part : parts) {
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                if (isFirstFile) {
                    isFirstFile = false;
                    atchFileVO = new AtchFileVO();
                    atchFileVO.setQnaQid(qnaQid);
                    fileDao.insertAtchFile(atchFileVO);
                }

                String originalFileName = fileName;
                long fileSize = part.getSize();
                String saveFileName = UUID.randomUUID().toString().replace("-", "");
                String saveFilePath = uploadPath + File.separator + saveFileName;

                String fileExt = originalFileName.lastIndexOf(".") < 0 ?
                        "" : originalFileName.substring(originalFileName.lastIndexOf(".") + 1);
                
                try {
                    part.write(saveFilePath);
                    AtchFileDetailVO detailVO = new AtchFileDetailVO();
                    detailVO.setAtchFileId(atchFileVO.getAtchFileId());
                    detailVO.setOrignlFileNm(originalFileName);
                    detailVO.setStreFileNm(saveFileName);
                    detailVO.setFileExtsn(fileExt);
                    detailVO.setFileStreCours(saveFilePath);
                    detailVO.setFileSize(fileSize);
                    detailVO.setFileCn("QnA 첨부파일");

                    fileDao.insertAtchFileDetail(detailVO);
                    part.delete();

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
