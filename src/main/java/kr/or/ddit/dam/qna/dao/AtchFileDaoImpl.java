package kr.or.ddit.dam.qna.dao;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.ibatis.session.SqlSession;

import kr.or.ddit.dam.vo.AtchFileDetailVO;
import kr.or.ddit.dam.vo.AtchFileVO;
import kr.or.ddit.mybatis.config.MybatisUtil;

public class AtchFileDaoImpl implements IAtchFileDao{

	private static IAtchFileDao atchFileDao = new AtchFileDaoImpl();
	
	private AtchFileDaoImpl() {
		
	}
	
	public static IAtchFileDao getInstance() {
		return atchFileDao;
	}
	
	@Override
	public int insertAtchFile(AtchFileVO atchFileVO) {
		
		int cnt = 0;
		
		try (SqlSession session = MybatisUtil.getInstance()){
			cnt = session.insert("atchFile.insertAtchFile", atchFileVO);
			if(cnt > 0) {
				session.commit();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return cnt;
	}

	@Override
	public int insertAtchFileDetail(AtchFileDetailVO atchFileDetailVO) {
		int cnt = 0;
		
		try (SqlSession session = MybatisUtil.getInstance()){
			cnt = session.insert("atchFile.insertAtchFileDetail", atchFileDetailVO);
			if(cnt > 0) {
				session.commit();
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return cnt;
	}

	@Override
	public AtchFileVO getAtchFile(AtchFileVO atchFileVO) {
		
		try(SqlSession session = MybatisUtil.getInstance(true)){
			atchFileVO = session.selectOne("atchFile.getAtchFile", atchFileVO);
			
		}catch(PersistenceException ex) {
			ex.printStackTrace();
		}
		
		return atchFileVO;
	}

	@Override
	public AtchFileDetailVO getAtchFileDetail(AtchFileDetailVO atchFileDetailVO) {
		try(SqlSession session = MybatisUtil.getInstance(true)){
			atchFileDetailVO = session.selectOne("atchFile.getAtchFileDetail", atchFileDetailVO);
			
		}catch(PersistenceException ex) {
			ex.printStackTrace();
		}
		
		return atchFileDetailVO;
	}

	public static void main(String[] args) {
		IAtchFileDao atchFileDao = AtchFileDaoImpl.getInstance();
		
		/*AtchFileVO atchFileVO = new AtchFileVO();
		int cnt = atchFileDao.insertAtchFile(atchFileVO);
		if(cnt>0) {
			System.out.println("Atch_file 테이블 등록 성공!!");
		}
		AtchFileDetailVO atchFileDetailVO = new AtchFileDetailVO();
		atchFileDetailVO.setAtchFileId(atchFileVO.getAtchFileId());
		atchFileDetailVO.setFileExtsn("jpg");
		atchFileDetailVO.setFileCn("");
		atchFileDetailVO.setFileSize(3000);
		atchFileDetailVO.setFileStreCours("d:/D_Other/1111");
		atchFileDetailVO.setStreFileNm("1111");
		atchFileDetailVO.setOrignlFileNm("tulip.jpg");
		
		cnt = atchFileDao.insertAtchFileDetail(atchFileDetailVO);
		
		if(cnt > 0) {
			System.out.println("atch_file_detail 테이블 등록 성공!");
		}
	
	AtchFileDetailVO atchFileDetailVO = new AtchFileDetailVO();
	atchFileDetailVO.setAtchFileId(1L);
	atchFileDetailVO.setFileSn(1);
	
	atchFileDetailVO = atchFileDao.getAtchFileDetail(atchFileDetailVO);
	
			
	System.out.println(atchFileDetailVO.toString());*/
		
	AtchFileVO atchFileVO = new AtchFileVO();
	atchFileVO.setAtchFileId(1L); //long타입
	
	atchFileVO = atchFileDao.getAtchFile(atchFileVO);
	
	for(AtchFileDetailVO detailVO : atchFileVO.getAtchFileDetailList()) {
		System.out.println(detailVO);
	}
		
	
	}

	@Override
	public int updateQnaQidForAtchFile(int qnaQid, Long atchFileId) {
	    int cnt = 0;
	    try (SqlSession session = MybatisUtil.getInstance()) {
	        Map<String, Object> paramMap = new HashMap<>();
	        paramMap.put("qnaQid", qnaQid);
	        paramMap.put("atchFileId", atchFileId);

	        cnt = session.update("atchFile.updateQnaQidForAtchFile", paramMap);
	        if (cnt > 0) {
	            session.commit();
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return cnt;
	}

	@Override
	public AtchFileVO selectAtchFileByQnaQid(int qnaQid) {
		AtchFileVO atchFileVO = null;
		try(SqlSession session = MybatisUtil.getInstance(true)) {
			/* 여러행
			 SELECT af.ATCH_FILE_ID, af.qna_qid, af.CREAT_DT, af.USE_AT,
		         afd.FILE_SN, afd.FILE_STRE_COURS, afd.STRE_FILE_NM, afd.ORIGNAL_FILE_NM,
		         afd.FILE_EXTSN, afd.FILE_CN, afd.FILE_SIZE
		  FROM qna_atch_file af
		  LEFT JOIN qna_atch_file_detail afd ON af.ATCH_FILE_ID = afd.ATCH_FILE_ID
		  WHERE af.qna_qid = 50
			 */
			atchFileVO = session.selectOne("atchFile.selectAtchFileByQnaQid", qnaQid);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return atchFileVO;
	}
}
