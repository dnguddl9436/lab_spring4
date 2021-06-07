package web.mvc;

import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

import com.google.gson.Gson;
import com.sun.corba.se.spi.orbutil.fsm.Guard.Result;
import com.util.HashMapBinder;

public class Board41Controller extends MultiActionController {
	Logger logger = Logger.getLogger(Board41Controller.class);
/*	<bean id="board-controller">
		<property name="boardLogic">*/
	private Board41Logic boardLogic = null;
	//setter메소드를 통하여 게으른 객체 주입
	public void setBoardLogic(Board41Logic boardLogic) {
		this.boardLogic = boardLogic;
	}
	//request로 유지
	//메소드를 정의하는 것은 가능하다.
	//파라미터가 없어도 괜찮은건가?
	public ModelAndView getBoardList(HttpServletRequest req, HttpServletResponse res) {
		logger.info("getBoardList 호출 성공");
		HashMapBinder hmb = new HashMapBinder(req);
		Map<String,Object> target = new HashMap<>();
		hmb.bind(target);
		List<Map<String,Object>> boardList = null;
		//boardList = boardLogic.getBoardList(target);//where bm_no=? and bm_title LIKE '%'||?||'%'
		logger.info("boardList:"+boardList);//
		ModelAndView mav = new ModelAndView();
		mav.setViewName("board/getBoardList");
		//mav.addObject("boardList",boardList);
//		RequestDispatcher view = req.getRequestDispatcher("jsonGetBoardList.jsp");
//		view.forward(req, res);
		logger.info("target:"+target);
		logger.info("target tostring:"+target.toString());
		return mav;
	}
	//json으로 내보내준다. - @RestController:String, @Controller:void, ModelAndView, String
	//@RestController
	public void jsonGetBoardList(HttpServletRequest req, HttpServletResponse res) throws Exception{
		logger.info("jsonGetBoardList 호출 성공");
		List<Map<String,Object>> boardList = null;
		boardList = boardLogic.getBoardList(null);
		Gson g = new Gson();
		String imsi = g.toJson(boardList);
		res.setContentType("application/json;charset=utf-8");
		PrintWriter out = res.getWriter();
		out.print(imsi);
	}
	public void boardInsert(HttpServletRequest req, HttpServletResponse res) throws Exception {
		logger.info("boardInsert 호출 성공");
		HashMapBinder hmb = new HashMapBinder(req);
		Map<String,Object> pmap = new HashMap<>();
		//사용자가 입력한 값이나 서버에서 클라이언트이게 요청한 값 넘김.
		hmb.bind(pmap);
		int result = 0;
		result = boardLogic.boardInsert(pmap);
		if(result == 1) {
			res.sendRedirect("./getBoardList.sp4");
		} else {
			res.sendRedirect("등록실패 페이지 이동처리");
		}
	}
	
}
