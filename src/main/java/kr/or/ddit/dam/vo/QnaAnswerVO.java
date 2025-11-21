package kr.or.ddit.dam.vo;

public class QnaAnswerVO {
	
	private int qnaAid; //답변글ID
	private String qnaContent; //답변내용
	private String qnaAnswerDate; //답변일
	private int qnaQid; //문의글ID
	
	public int getQnaAid() {
		return qnaAid;
	}
	public void setQnaAid(int qnaAid) {
		this.qnaAid = qnaAid;
	}
	public String getQnaContent() {
		return qnaContent;
	}
	public void setQnaContent(String qnaContent) {
		this.qnaContent = qnaContent;
	}
	public String getQnaAnswerDate() {
		return qnaAnswerDate;
	}
	public void setQnaAnswerDate(String qnaAnswerDate) {
		this.qnaAnswerDate = qnaAnswerDate;
	}
	public int getQnaQid() {
		return qnaQid;
	}
	public void setQnaQid(int qnaQid) {
		this.qnaQid = qnaQid;
	}

	
	
}
