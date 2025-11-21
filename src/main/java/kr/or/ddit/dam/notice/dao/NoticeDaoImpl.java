package kr.or.ddit.dam.notice.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.NoticeVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class NoticeDaoImpl implements INoticeDao {

	private static INoticeDao dao;
	private NoticeDaoImpl() {};
	
	public static INoticeDao getInstance() {
		if(dao == null) dao = new NoticeDaoImpl();
		return dao;
	}

	@Override
	public int insertNotice(NoticeVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
		
		try {
			res = session.insert("notice.insertNotice", vo);
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
	public int updateNotice(NoticeVO vo) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0;
		
		try {
			res = session.update("notice.updateNotice", vo);
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
	public int deleteNotice(int noticeId) {
		SqlSession session = MybatisUtil.getInstance();
		int res = 0; 
		
		try {
			res = session.delete("notice.deleteNotice", noticeId);
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
	public List<NoticeVO> getAllNotice(Map<String, Object> map) {
		SqlSession session = MybatisUtil.getInstance();
		List<NoticeVO> list = null;
		
		try {
			list = session.selectList("notice.getAllNotice", map);
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			if(session != null) {
				session.commit(); //close랑 commit순서가 바뀌면 안됨
				session.close();
			}
		}
		return list;
	}

	@Override
	public NoticeVO getNoticeById(int noticeId) {
		SqlSession session = MybatisUtil.getInstance();
		NoticeVO evo = null;
		
		try {
			evo = session.selectOne("notice.getNoticeById", noticeId);
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
}
