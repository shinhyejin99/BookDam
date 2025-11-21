package kr.or.ddit.dam.nomem.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.NoMemVO;


public interface INoMemDao {

	public List<NoMemVO> getAllNoMember();
	
	//로그인
	public List<NoMemVO> NoMemberOrder(NoMemVO nvo);
	
	/**
	 * 결제 후, 비회원의 아이디와 비밀번호를 insert
	 * @param vo 비회원 아이디(이메일), 비밀번호가 들어있는 vo
	 * @return 성공하면 1, 실패하면 0
	 */
	public int insertNoMember(SqlSession sqlSession, NoMemVO vo);
	
}
