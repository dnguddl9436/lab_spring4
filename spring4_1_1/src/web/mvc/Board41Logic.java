package web.mvc;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

public class Board41Logic {
	Logger logger = Logger.getLogger(Board41Logic.class);
	private Board41MDao boardMDao = new Board41MDao();
	public void setBoardMDao(Board41MDao boardMDao) {
		this.boardMDao = boardMDao;
	}
	private Board41SDao boardSDao = new Board41SDao();
	public void setBoardSDao(Board41SDao boardSDao) {
		this.boardSDao = boardSDao;
	}
	
	public List<Map<String,Object>> getBoardList(Map<String, Object> pmap) {
		logger.info("getBoardList 호출 성공");
		List<Map<String,Object>> boardList = null;
		boardList = boardMDao.getBoardList(pmap);
		return boardList;
	}
	public int boardInsert(Map<String, Object> pmap) {
		logger.info("boardInsert 호출 성공");
		int result = 0;
		int fileOk = 0;
		boardMDao.boardMInsert(pmap);
		//첨부파일이 있어?
		
		if(pmap.containsKey("bs_file")) {
			fileOk = boardSDao.boardSInsert(pmap);
		}
		result = 1;
		return result;
	}

}
