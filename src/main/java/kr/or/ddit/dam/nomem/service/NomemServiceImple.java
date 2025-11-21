package kr.or.ddit.dam.nomem.service;

import java.util.List;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.nomem.dao.INoMemDao;
import kr.or.ddit.dam.nomem.dao.NoMemDaoImpl;
import kr.or.ddit.dam.vo.NoMemVO;

public class NomemServiceImple implements INomemService {

	// 필드
	private static INomemService noservice;
	
	private INoMemDao nodao;
	
//  생성자
    private NomemServiceImple() {
        nodao = NoMemDaoImpl.getNoDao();
    }
	
	// 메소드
	public static INomemService getNoService() {
        if (noservice == null) noservice = new NomemServiceImple();
        return noservice;
    }
	
    
	@Override
	public int insertNoMember(SqlSession sqlSession, NoMemVO vo) {
		return nodao.insertNoMember(sqlSession, vo);
	}

    @Override
    public List<NoMemVO> getAllNoMember() {
        return nodao.getAllNoMember();
    }

    @Override
    public List<NoMemVO> NoMemberOrder(NoMemVO nvo) {
        return nodao.NoMemberOrder(nvo);
    }
}





