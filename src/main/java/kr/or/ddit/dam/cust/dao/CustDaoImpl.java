package kr.or.ddit.dam.cust.dao;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.CustVO;

import kr.or.ddit.mybatis.config.MybatisUtil;

public class CustDaoImpl implements ICustDao {

    private static CustDaoImpl dao;

    public static CustDaoImpl getDao() {
        if (dao == null) {
            dao = new CustDaoImpl();
        }
        return dao;
    }

    private CustDaoImpl() {}

    @Override
    public List<CustVO> getAllCust() {
        SqlSession session = MybatisUtil.getInstance();
        List<CustVO> list = null;
        try {
            list = session.selectList("cust.getAllCust");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                // select는 commit 필요없음
                session.close();
            }
        }
        return list;
    }

    @Override
    public CustVO getCustId(String id) {
        SqlSession session = MybatisUtil.getInstance();
        CustVO vo = null;
        try {
            vo = session.selectOne("cust.getCustId", id);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                // select라 commit 빼고 close만
                session.close();
            }
        }
        return vo;
    }

    @Override
    public int insertCust(CustVO vo) {
        SqlSession session = MybatisUtil.getInstance();
        int res = 0;
        try {
            res = session.insert("cust.insertCust", vo);
            if (res > 0) {
                session.commit();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return res;
    }

    @Override
    public int checkCustIdExists(String custId) {
        SqlSession session = MybatisUtil.getInstance();
        int res = 0;
        try {
            res = session.selectOne("cust.checkCustIdExists", custId);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return res;
    }

    @Override
    public CustVO loginCust(CustVO cvo) {
        SqlSession session = MybatisUtil.getInstance();
        CustVO res = null;
        try {
            res = session.selectOne("cust.loginCust", cvo);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return res;
    }

    @Override
    public String mailFind(String name, String tel) {
        SqlSession session = MybatisUtil.getInstance();
        String id = null;
        try {
            id = session.selectOne("cust.mailFind", Map.of("cust_name", name, "cust_tel", tel));
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return id;
    }

    @Override
    public int updateCust(CustVO cvo) {
        SqlSession session = MybatisUtil.getInstance();
        int cnt = 0;
        try {
            cnt = session.update("cust.updateCust", cvo);
            if(cnt > 0) {
                session.commit();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return cnt;
    }

	@Override
	public CustVO getCustById(String cust_id) {
		
		SqlSession session = MybatisUtil.getInstance();
	    CustVO vo = null;
	    try {
	        vo = session.selectOne("cust.getCustById", cust_id);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        if (session != null) {
	            session.close();
	        }
	    }
	    return vo;
	}
	
	
	@Override
    public List<CustVO> getMemberGradesByDateRange(Map<String, Object> paramMap) {
		 
		SqlSession session = MybatisUtil.getInstance();
		    List<CustVO> memberGrades = null;
		    try {
		        memberGrades = session.selectList("cust.getMemberGradesByDateRange", paramMap);
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        if (session != null) {
		            session.close();
		        }
		    }
		    return memberGrades;
		}

    /**
     * 회원 등급을 업데이트
     * @param params cust_id와 mem_grade를 포함한 Map
     * @return 업데이트된 레코드 수
     */
    @Override
    public int updateMemberGrade(Map<String, Object> params) {
        SqlSession session = MybatisUtil.getInstance();
        int result = 0;
        try {
            result = session.update("cust.updateMemberGrade", params);
            if (result > 0) {
                session.commit();
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (session != null) {
                session.close();
            }
        }
        return result;
    }
}

	
