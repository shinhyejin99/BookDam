package kr.or.ddit.dam.event.dao;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.EventVO;

public interface IEventDao {

	// 이벤트 공통 등록
    public int insertEvent(EventVO vo);
    
    // 이벤트 Nomal 등록 (내용과 오픈일)
    public int insertEventNomal(EventVO vo);
    
    // 이벤트 공통 수정
    public int updateEvent(EventVO vo);

    //event_nomal 테이블 수정
    public int updateEventNomal(EventVO vo);
    
    // 이벤트 공통 삭제
    public int deleteEvent(int eventId);
    
    // nomal삭제
    public int deleteEventNomal(int eventId);
    
    // 목록에서 행사 하나클릭했을때 가져올 값
    public EventVO getEventById(int eventId);
    
    // 전체 이벤트 목록 조회
    public List<EventVO> getAllEvents(Map<String, Object> map);

}
