package kr.or.ddit.dam.vo;

public class EventVO {

	// 공통
	private int eventId; // 이벤트ID
	private String eventTitle; // 글제목
	private String eventDate; // 작성일
	private String eventType; // 이벤트 유형
	private String eventOpenDate; // 이벤트 시작일시
	
	// nomal 전용
	private String eventContent; // 글내용
	

	// 공통
	public int getEventId() {
		return eventId;
	}
	public void setEventId(int eventId) {
		this.eventId = eventId;
	}
	public String getEventTitle() {
		return eventTitle;
	}
	public void setEventTitle(String eventTitle) {
		this.eventTitle = eventTitle;
	}
	public String getEventDate() {
		return eventDate;
	}
	public void setEventDate(String eventDate) {
		this.eventDate = eventDate;
	}
	public String getEventType() {
		return eventType;
	}
	public void setEventType(String eventType) {
		this.eventType = eventType;
	}
	public String getEventOpenDate() {
		return eventOpenDate;
	}
	public void setEventOpenDate(String eventOpenDate) {
		this.eventOpenDate = eventOpenDate;
	}
	// nomal 전용
	public String getEventContent() {
		return eventContent;
	}
	public void setEventContent(String eventContent) {
		this.eventContent = eventContent;
	}
	
	@Override
	public String toString() {
		return "EventVO [eventId=" + eventId + ", eventTitle=" + eventTitle + ", eventDate=" + eventDate
				+ ", eventType=" + eventType + ", eventOpenDate=" + eventOpenDate + ", eventContent=" + eventContent
				+ "]";
	}
	
	
}
