package kr.or.ddit.dam.notice.service;

import java.util.List;
import java.util.Map;

import kr.or.ddit.dam.vo.NoticeVO;

public interface INoticeService {

    // 공지사항 등록
    int insertNotice(NoticeVO vo);

    // 공지사항 수정
    int updateNotice(NoticeVO vo);

    // 공지사항 삭제
    int deleteNotice(int noticeId);
    
    // 공지사항 전체 조회
    List<NoticeVO> getAllNotice(Map<String, Object>map);

    // 공지사항 상세 조회
    NoticeVO getNoticeById(int noticeId);
}
