package kr.or.ddit.dam.vo;

public class QnaVO {
	
	private int qnaQid; //문의글 ID
	private String custId; //고객ID
	private String qnaTitle; //글제목
	private String qnaContent; //글내용
	private String qnaDate; //작성일
	private String qnaStatus; //답변상태
	private String qnaType; //문의글 유형
	
	private String qnaFileName; //원래 파일이름
	private String qnaFilePath; //저장된 파일경로

    private Long atchFileId; // 첨부파일 ID (Qna 테이블에 이 필드가 있다면 매핑)
    private AtchFileVO atchFileVO; // Qna에 연결된 첨부파일 정보를 담을 필드

    private String memMail; // 작성자 이메일
    
    public AtchFileVO getAtchFileVO() {
		return atchFileVO;
	}
	public void setAtchFileVO(AtchFileVO atchFileVO) {
		this.atchFileVO = atchFileVO;
	}
	public int getQnaQid() {
		return qnaQid;
	}
	public void setQnaQid(int qnaQid) {
		this.qnaQid = qnaQid;
	}
	public String getCustId() {
		return custId;
	}
	public void setCustId(String custId) {
		this.custId = custId;
	}
	public String getQnaTitle() {
		return qnaTitle;
	}
	public void setQnaTitle(String qnaTitle) {
		this.qnaTitle = qnaTitle;
	}
	public String getQnaContent() {
		return qnaContent;
	}
	public void setQnaContent(String qnaContent) {
		this.qnaContent = qnaContent;
	}
	public String getQnaDate() {
		return qnaDate;
	}
	public void setQnaDate(String qnaDate) {
		this.qnaDate = qnaDate;
	}
	public String getQnaStatus() {
		return qnaStatus;
	}
	public void setQnaStatus(String qnaStatus) {
		this.qnaStatus = qnaStatus;
	}
	public String getQnaType() {
		return qnaType;
	}
	public void setQnaType(String qnaType) {
		this.qnaType = qnaType;
	}
	public String getQnaFileName() {
		return qnaFileName;
	}
	public void setQnaFileName(String qnaFileName) {
		this.qnaFileName = qnaFileName;
	}
	public String getQnaFilePath() {
		return qnaFilePath;
	}
	public void setQnaFilePath(String qnaFilePath) {
		this.qnaFilePath = qnaFilePath;
	}
	public Long getAtchFileId() {
		return atchFileId;
	}
	public void setAtchFileId(Long atchFileId) {
		this.atchFileId = atchFileId;
	}
	
	public String getMemMail() {
		return memMail;
	}
	public void setMemMail(String memMail) {
		this.memMail = memMail;
	}
	@Override
	public String toString() {
		return "QnaVO [qnaQid=" + qnaQid + ", custId=" + custId + ", qnaTitle=" + qnaTitle + ", qnaContent="
				+ qnaContent + ", qnaDate=" + qnaDate + ", qnaStatus=" + qnaStatus + ", qnaType=" + qnaType
				+ ", qnaFileName=" + qnaFileName + ", qnaFilePath=" + qnaFilePath + ", atchFileId=" + atchFileId
				+ ", atchFileVO=" + atchFileVO + ", memMail=" + memMail + "]";
	}

	

	
	
	
}
