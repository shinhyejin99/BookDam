package kr.or.ddit.dam.notice.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.notice.dao.INoticeDao;
import kr.or.ddit.dam.notice.dao.NoticeDaoImpl;
import kr.or.ddit.dam.vo.NoticeVO;

public class NoticeServiceImpl implements INoticeService {

	private static INoticeService service;
	
	public static INoticeService getService() {
		if(service == null) service = new NoticeServiceImpl();
		return service;
	}
	
	private INoticeDao dao;
	
	private NoticeServiceImpl() {
		dao = NoticeDaoImpl.getInstance();
	}
	
	@Override
	public int insertNotice(NoticeVO vo) {
		return dao.insertNotice(vo);
	}

	@Override
	public int updateNotice(NoticeVO vo) {
		return dao.updateNotice(vo);
	}

	@Override
	public int deleteNotice(int noticeId) {
		return dao.deleteNotice(noticeId);
	}

	@Override
	public List<NoticeVO> getAllNotice(Map<String, Object> map) {
		return dao.getAllNotice(map);
	}

	@Override
	public NoticeVO getNoticeById(int noticeId) {
		return dao.getNoticeById(noticeId);
	}

}
