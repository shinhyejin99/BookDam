package kr.or.ddit.dam.vo;

import java.time.LocalDate;
import java.util.List;

public class AtchFileVO {
	
	private int qnaQid; //게시글번호
	
	private Long atchFileId; //첨부파일ID
	private LocalDate creatDt; //생성일시
	private String useAt; //사용여부
	
	
	//세부첨부파일 목록
	private List<AtchFileDetailVO> atchFileDetailList;
	
	
	public List<AtchFileDetailVO> getAtchFileDetailList() {
		return atchFileDetailList;
	}
	public void setAtchFileDetailList(List<AtchFileDetailVO> atchFileDetailList) {
		this.atchFileDetailList = atchFileDetailList;
	}
	
	public Long getAtchFileId() {
		return atchFileId;
	}
	public void setAtchFileId(Long atchFileId) {
		this.atchFileId = atchFileId;
	}
	public LocalDate getCreatDt() {
		return creatDt;
	}
	public void setCreatDt(LocalDate creatDt) {
		this.creatDt = creatDt;
	}
	public String getUseAt() {
		return useAt;
	}
	public void setUseAt(String useAt) {
		this.useAt = useAt;
	}
	public int getQnaQid() {
		return qnaQid;
	}
	public void setQnaQid(int qnaQid) {
		this.qnaQid = qnaQid;
	}
	@Override
	public String toString() {
		return "AtchFileVO [qnaQid=" + qnaQid + ", atchFileId=" + atchFileId + ", creatDt=" + creatDt + ", useAt="
				+ useAt + ", atchFileDetailList=" + atchFileDetailList + "]";
	}

	
	
}
