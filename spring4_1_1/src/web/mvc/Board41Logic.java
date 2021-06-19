package web.mvc;

import java.io.File;
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
		String gubun = null;
		if(pmap!=null && pmap.get("gubun")!=null) {
				gubun = pmap.get("gubun").toString();
		}
		if(gubun!=null && "detail".equals(gubun)) {
			int bm_no = 0;
			bm_no = Integer.parseInt(pmap.get("bm_no").toString());
			boardMDao.hitCount(bm_no);
		}
		boardList = boardMDao.getBoardList(pmap);
		return boardList;
	}
	//=>board/boardInsert.sp4?bm_no=100&bm_title=%EC%96%B5&bs_file=a.txt&bm_writer=%EC%9D%B4%EC%88%9C%EC%8B%A0&bm_email=test@hot.com&bm_content=%EC%97%B0%EC%8A%B5&bm_pw=123
	public int boardInsert(Map<String, Object> pmap) {
		logger.info("boardInsert 호출 성공");
		int result = 0;
		int bm_no = 0;
		int bm_group = 0;
		if(pmap.get("bm_no")==null) {
			logger.info("bm_no는 null");
			bm_no = boardMDao.getBmNo();
			pmap.put("bm_no", bm_no);
		}
		if(pmap.get("bm_group")!=null) {//read.jsp눌렀다
			bm_group = Integer.parseInt(pmap.get("bm_group").toString());
		}
		//댓글이야?
		if(bm_group > 0) {
			boardMDao.bmStepUpdate(pmap);//조건에 맞지 않으면 처리가 생략될 수 있다.
			pmap.put("bm_pos", Integer.parseInt(pmap.get("bm_pos").toString())+1);
			pmap.put("bm_step", Integer.parseInt(pmap.get("bm_step").toString())+1);
		}
		//너 새글이구나
		else {
			bm_group = boardMDao.getBmGroup();
			pmap.put("bm_group", bm_group);
			pmap.put("bm_pos", 0);
			pmap.put("bm_step", 0);
		}
		//첨부파일이 있어?
		if((pmap.get("bs_file")!=null)&&(pmap.get("bs_file").toString().length() > 0)) {
			//pmap.put("bm_no", bm_no);
			logger.info("첨부파일 처리 로직 경유");
			pmap.put("bm_seq", 1);
			boardSDao.boardSInsert(pmap);
		}
		boardMDao.boardMInsert(pmap);
		
		result = 1;
		return result;
	}

	public int boardUpdate(Map<String, Object> pmap) {
		logger.info("boardUpdate 호출 성공");
		int result = 0;
		result = boardMDao.boardMUpdate(pmap);
		return result;
	}

	public int boardDelete(Map<String, Object> pmap) {
		logger.info("boardDelete 호출 성공");
		int result = 0;
		try {
			result = boardMDao.boardMDelete(pmap);
			if(result == 1) {
				String filePath = "D:\\portfolio_kosmo\\lab_spring4\\spring4_1_1\\WebContent\\pds\\";
				String filename = pmap.get("bs_file").toString();
				String fullName = filePath+filename;
				//실제로 존재하는 파일이름을 객체로 생성해주는 클래스
				File file = new File(fullName);
				if(file!=null) {
					if(file.exists()) {
						boolean isOk = file.delete();
						logger.info(isOk);
						pmap.put("bs_seq", 1);
						boardSDao.boardSDelete(pmap);
					}
				}
			}
		} catch (Exception e) {
			logger.info("Exception: "+e.toString());
		}
		return result;
	}///////////////end of boardDelete

	public List<Map<String, Object>> getChatList(Map<String, Object> target) {
		List<Map<String,Object>> chatList = null;
		String nickname = target.get("nickname").toString();
		chatList = boardMDao.getChatList(nickname);
		return chatList;
	}

	public List<Map<String, Object>> enterChatroom(Map<String, Object> target) {
		List<Map<String,Object>> enterChatroom = null;
		String nickname = target.get("RoomUid").toString();
		enterChatroom = boardMDao.enterChatroom(nickname);
		return enterChatroom;
	}

}
