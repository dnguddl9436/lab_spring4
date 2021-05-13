package kosmo80.mvc.sp4;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.multiaction.MultiActionController;

public class DeptController extends MultiActionController {
	public ModelAndView deptList(HttpServletRequest req, HttpServletResponse res) {
		ModelAndView mav = new ModelAndView();
		return mav;
	}
}
