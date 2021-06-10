package web.mvc;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;

import com.vo.BoardMVO;

public class Board41MDao {
	Logger logger = Logger.getLogger(Board41MDao.class);
	private SqlSessionTemplate sqlSessionTemplate = null;
	public void setSqlSessionTemplate(SqlSessionTemplate sqlSessionTemplate) {
		this.sqlSessionTemplate = sqlSessionTemplate;
	}
	public List<Map<String, Object>> getBoardList(Map<String, Object> pmap) {
		List<Map<String, Object>> boardList = null;
		//List<BoardMVO> boardList2 = null;
		boardList = sqlSessionTemplate.selectList("getBoardList",pmap);
		/*
		boardList2 = sqlSessionTemplate.selectList("getBoardMap",pmap);
		for(BoardMVO bmvo:boardList2) {
			logger.info("bmvo : "+bmvo);
			logger.info("bmvo : "+bmvo.getBm_title());
			logger.info("bmvo : "+bmvo.getBsVO().getBs_seq());
			logger.info("bmvo : "+bmvo.getBs_file());
		}
		*/
		return boardList;
	}
	public int boardMInsert(Map<String, Object> pmap) {
		logger.info("boardMInsert 호출 성공");
		int result = 0;
		result = 1;
		sqlSessionTemplate.insert("boardMInsert",pmap);
		return result;
	}
	public void bmStepUpdate(Map<String, Object> pmap) {
		logger.info("bmStepUpdate 호출 성공");
		sqlSessionTemplate.insert("bmStepUpdate",pmap);
		
	}
	public int getBmGroup() {
		logger.info("getBmGroup 호출 성공");
		int result = 0;
		result = sqlSessionTemplate.insert("getBmGroup");
		return result;
	}
	
}