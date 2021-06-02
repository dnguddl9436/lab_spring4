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
		boardList = new ArrayList<>();
		Map<String,Object> rmap = new HashMap<>();
		rmap.put("mem_id", "tomato");
		rmap.put("mem_pw", "123");
		rmap.put("mem_name", "이순신");
		boardList.add(rmap);
		rmap = new HashMap<>();
		rmap.put("mem_id", "apple");
		rmap.put("mem_pw", "125");
		rmap.put("mem_name", "강감찬");
		boardList.add(rmap);
		rmap = new HashMap<>();
		rmap.put("mem_id", "nice");
		rmap.put("mem_pw", "126");
		rmap.put("mem_name", "김유신");
		boardList.add(rmap);
		boardLogic.getBoardList(target);//where bm_no=? and bm_title LIKE '%'||?||'%'
		ModelAndView mav = new ModelAndView();
		String name = "이순신";
		//mav.setViewName("a.jsp");
		mav.addObject("boardList",boardList);
		HttpSession session = req.getSession();
		session.setAttribute("name", name);
//		RequestDispatcher view = req.getRequestDispatcher("jsonGetBoardList.jsp");
//		view.forward(req, res);
		return mav;
	}
	//json으로 내보내준다. - @RestController:String, @Controller:void, ModelAndView, String
	//@RestController
	public void jsonGetBoardList(HttpServletRequest req, HttpServletResponse res) throws Exception{
		logger.info("jsonGetBoardList 호출 성공");
		List<Map<String,Object>> boardList = null;
		boardList = new ArrayList<>();
		Map<String,Object> rmap = new HashMap<>();
		rmap.put("mem_id", "tomato");
		rmap.put("mem_pw", "123");
		rmap.put("mem_name", "이순신");
		boardList.add(rmap);
		rmap = new HashMap<>();
		rmap.put("mem_id", "apple");
		rmap.put("mem_pw", "125");
		rmap.put("mem_name", "강감찬");
		boardList.add(rmap);
		rmap = new HashMap<>();
		rmap.put("mem_id", "nice");
		rmap.put("mem_pw", "126");
		rmap.put("mem_name", "김유신");
		boardList.add(rmap);
		Gson g = new Gson();
		String imsi = g.toJson(boardList);
		res.setContentType("application/json;charset=utf-8");
		PrintWriter out = res.getWriter();
		out.print(imsi);
	}
	
}
