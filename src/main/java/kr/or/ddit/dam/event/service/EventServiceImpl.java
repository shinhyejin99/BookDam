package kr.or.ddit.dam.event.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.event.dao.EventDaoImpl;
import kr.or.ddit.dam.event.dao.IEventDao;
import kr.or.ddit.dam.vo.EventVO;

public class EventServiceImpl implements IEventService {

	// 1. 싱글톤 패턴
	private static IEventService service;
	
	public static IEventService getService() {
		if(service == null) service = new EventServiceImpl();
		return service;
	}
	
	// 2. DAO 객체 생성
	private IEventDao dao;
	
	// 3. 생성자에서 DAO 연결
	private EventServiceImpl() {
		dao = EventDaoImpl.getInstance();
	}

	@Override
	public int insertEvent(EventVO vo) {
		 int res1 = dao.insertEvent(vo);          // 1. event 테이블에 insert
		 int res2 = dao.insertEventNomal(vo);     // 2. event_nomal 테이블에 insert

		 // 3. 두 insert 모두 성공하면 성공 처리
		 return (res1 > 0 && res2 > 0) ? 1 : 0;
	}

	@Override
	public int updateEvent(EventVO vo) {
	    int res1 = dao.updateEvent(vo);           // EVENT 테이블 (제목, 타입 등)
	    int res2 = dao.updateEventNomal(vo);      // EVENT_NOMAL 테이블 (내용)
	    return (res1 > 0 || res2 > 0) ? 1 : 0;
	}

	@Override
	public int deleteEvent(int eventId) {
		// 1. 자식 테이블 먼저 삭제
	    dao.deleteEventNomal(eventId);
	    
	    // 2. 부모 테이블 삭제
		return dao.deleteEvent(eventId);
	}

	@Override
	public List<EventVO> getAllEvents(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return dao.getAllEvents(map);
	}

	@Override
	public int insertEventNomal(EventVO vo) {
		// TODO Auto-generated method stub
		return dao.insertEventNomal(vo);
	}

	@Override
	public EventVO getEventById(int eventId) {
		// TODO Auto-generated method stub
		return dao.getEventById(eventId);
	}

	@Override
	public int deleteEventNomal(int eventId) {
		// TODO Auto-generated method stub
		return dao.deleteEventNomal(eventId);
	}

	@Override
	public int updateEventNomal(EventVO vo) {
		// TODO Auto-generated method stub
		return dao.updateEventNomal(vo);
	}


}
