package kr.or.ddit.dam.book.service;

import java.util.List;

import kr.or.ddit.dam.book.dao.BestBookDaoImpl;
import kr.or.ddit.dam.book.dao.IBestBookDao;
import kr.or.ddit.dam.vo.BestBookVO;

public class BestBookServiceImpl implements IBestBookService{

	//싱글톤패턴
	private static IBestBookService service;
	
	public static IBestBookService getService() {
		if(service == null) service = new BestBookServiceImpl();
		return service;
	}
	
	//dao객체
	private IBestBookDao dao;

	//dao초기화
	private BestBookServiceImpl() {
		dao = BestBookDaoImpl.getDao();
	}
	
	@Override
	public List<BestBookVO> selectBestBook() {
		// TODO Auto-generated method stub
		return dao.selectBestBook();
	}

	@Override
	public List<BestBookVO> selectAge(String ageRange) {
		// TODO Auto-generated method stub
		return dao.selectAge(ageRange);
	}

	@Override
	public String selectCategory() {
		// TODO Auto-generated method stub
		return dao.selectCategory();
	}

	@Override
	public List<BestBookVO> selectTopCategory(String category) {
		// TODO Auto-generated method stub
		return dao.selectTopCategory(category);
	}
	

}
