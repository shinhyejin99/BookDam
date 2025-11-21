package kr.or.ddit.dam.cust.service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.cust.dao.CustDaoImpl;
import kr.or.ddit.dam.cust.dao.ICustDao;
import kr.or.ddit.dam.mem.service.IMemService;
import kr.or.ddit.dam.mem.service.MemServiceImpl;
import kr.or.ddit.dam.pay.dao.IPayDao;
import kr.or.ddit.dam.pay.dao.PayDaoImpl;
import kr.or.ddit.dam.pay.service.IPayService;
import kr.or.ddit.dam.pay.service.PayServiceImpl;
import kr.or.ddit.dam.vo.CustVO;
import kr.or.ddit.dam.vo.MemVO;
import kr.or.ddit.mybatis.config.MybatisUtil;


public class CustServiceImpl implements ICustService {

    private static ICustService service;

    public static ICustService getService() {
        if (service == null)
            service = new CustServiceImpl();
        return service;
    }

    private ICustDao dao;

    public CustServiceImpl() {
        dao = CustDaoImpl.getDao();
    }

    @Override
    public List<CustVO> getAllCust() {
        return dao.getAllCust();
    }

    @Override
    public CustVO getCustId(String id) {
        System.out.println("getCustId() 호출 - ID: " + id);
        return dao.getCustId(id);
    }

    @Override
    public int insertCust(CustVO vo) throws Exception {
        int count = dao.checkCustIdExists(vo.getCust_id());
        if (count > 0) {
            throw new Exception("이미 존재하는 고객 ID 입니다.");
        }
        int res = dao.insertCust(vo);
        System.out.println("고객 등록 결과: " + res);

        // 등록 후 바로 고객 정보 조회 (확인용)
        if (res > 0) {
            CustVO saved = dao.getCustId(vo.getCust_id());
			
            if (saved == null) {
                System.err.println("WARNING: 등록 직후 고객 정보 조회 실패");
            }
        }
        return res;
    }
    
    // 고객이 존재하는지 확인하는 메소드 (가영 보충)
    public int checkCustIdExists(String cust_id) {
    	return dao.checkCustIdExists(cust_id);
    }

    @Override
    public CustVO loginCust(CustVO cvo) {
        return dao.loginCust(cvo);
    }

    @Override
    public String mailFind(String name, String tel) {
        return dao.mailFind(name, tel);
    }

    @Override
    public int updateCust(CustVO cvo) {
        String zip = cvo.getCust_zip();
        if (zip != null) {
            if (zip.length() > 6) {
                cvo.setCust_zip(zip.substring(0, 6));
                String remainingAddr = zip.substring(6).trim();
                if (cvo.getCust_addr1() == null) {
                    cvo.setCust_addr1(remainingAddr);
                } else {
                    cvo.setCust_addr1(cvo.getCust_addr1() + " " + remainingAddr);
                }
            }
        }
        return dao.updateCust(cvo);
    }

	@Override
	public CustVO getCustById(String cust_id) {
		
		return dao.getCustById(cust_id);
	}
	
	 /**
     * 순수 구매액을 조회하는 메소드 (1개월 기간에 대한 계산)
     * @param startDate 시작 날짜
     * @param endDate 종료 날짜
     * @return 순수 구매액과 고객 정보를 포함한 리스트
     */
    @Override
    public List<CustVO> getMemberGrades(LocalDate startDate, LocalDate endDate) {
    	
    	Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("startDate", startDate);
        paramMap.put("endDate", endDate);
        
        return dao.getMemberGradesByDateRange(paramMap);
    }

    /**
     * 고객의 등급을 업데이트하는 메소드
     * @param cust_id 고객 아이디
     * @param mem_grade 새로운 등급
     * @return 성공 여부
     */
    @Override
    public boolean updateMemberGrade(String cust_id, String mem_grade) {
        Map<String, Object> params = Map.of("cust_id", cust_id, "mem_grade", mem_grade);
        return dao.updateMemberGrade(params) > 0;
    }
}
