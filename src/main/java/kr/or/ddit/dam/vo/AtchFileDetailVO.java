package kr.or.ddit.dam.vo;

public class AtchFileDetailVO {
	
	private Long atchFileId; //첨부파일ID
	private int fileSn; //파일순번
	private String fileExtsn; //파일확장자
	private String fileCn; //파일내용
	private long fileSize; //파일크기
	private String fileStreCours; //파일저장경로
	private String streFileNm; //저장파일명
	private String orignalFileNm; //원본파일명
	public Long getAtchFileId() {
		return atchFileId;
	}
	public void setAtchFileId(Long atchFileId) {
		this.atchFileId = atchFileId;
	}
	public int getFileSn() {
		return fileSn;
	}
	public void setFileSn(int fileSn) {
		this.fileSn = fileSn;
	}
	public String getFileExtsn() {
		return fileExtsn;
	}
	public void setFileExtsn(String fileExtsn) {
		this.fileExtsn = fileExtsn;
	}
	public String getFileCn() {
		return fileCn;
	}
	public void setFileCn(String fileCn) {
		this.fileCn = fileCn;
	}
	public long getFileSize() {
		return fileSize;
	}
	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}
	public String getFileStreCours() {
		return fileStreCours;
	}
	public void setFileStreCours(String fileStreCours) {
		this.fileStreCours = fileStreCours;
	}
	public String getStreFileNm() {
		return streFileNm;
	}
	public void setStreFileNm(String streFileNm) {
		this.streFileNm = streFileNm;
	}
	public String getOrignlFileNm() {
		return orignalFileNm;
	}
	public void setOrignlFileNm(String orignlFileNm) {
		this.orignalFileNm = orignlFileNm;
	}
	
	
}
