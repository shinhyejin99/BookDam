package kr.or.ddit.dam.event.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.EventVO;
import kr.or.ddit.dam.vo.QnaVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class EventDaoImpl implements IEventDao{
	
	// 1. 싱글톤 객체 생성
	private static IEventDao dao;
	
	// 2. private 생성자
	private EventDaoImpl() {};
	
	// 3. 인스턴스 반환 메서드
	public static IEventDao getInstance() {
		if (dao == null) dao = new EventDaoImpl();
		return dao;
	}

	@Override
	public int insertEvent(EventVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; // 1
		
		try {
			res = session.insert("event.insertEvent", vo); //2
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res; //3
	}

	@Override
	public int updateEvent(EventVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; // 1
		
		try {
			res = session.update("event.updateEvent", vo); //2
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res; //3
	}

	@Override
	public int deleteEvent(int eventId) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; // 1
		
		try {
			res = session.delete("event.deleteEvent", eventId); //2
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res; //3
	}

	@Override
	public List<EventVO> getAllEvents(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		List<EventVO> list = null; //1
		
		try {
			list = session.selectList("event.getAllEvents", map); //2
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		return list; //3
	}

	@Override
	public int insertEventNomal(EventVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
		
		try {
			res = session.insert("event.insertEventNomal", vo);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res;
	}

	@Override
	public EventVO getEventById(int eventId) {
		SqlSession session = MybatisUtil.getInstance();
		EventVO evo = null;
		
		try {
			evo = session.selectOne("event.getEventById", eventId);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return evo;
	}

	@Override
	public int deleteEventNomal(int eventId) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; // 1
		
		try {
			res = session.delete("event.deleteEventNomal", eventId); //2
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res; //3
	}

	@Override
	public int updateEventNomal(EventVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; // 1
		
		try {
			res = session.update("event.updateEventNomal", vo); //2
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit();
				session.close();
			}
		}
		return res; //3
	}


	
}
