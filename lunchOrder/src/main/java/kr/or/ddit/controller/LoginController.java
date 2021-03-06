package kr.or.ddit.controller;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.WebApplicationContext;

import kr.or.ddit.enumpkg.ServiceResult;
import kr.or.ddit.service.LunchService;
import kr.or.ddit.vo.UserVO;

@Controller
public class LoginController {
	
	@Inject
	private LunchService service;
	@Inject
	private WebApplicationContext container;
	private ServletContext application;
	@PostConstruct
	public void init() {
		application = container.getServletContext();
	}
	private static final Logger logger = LoggerFactory.getLogger(LoginController.class);
	
	@RequestMapping(value="/login/loginCheck.do", method = RequestMethod.GET)
	public String loginPage() {
		return "login";
	}
	
	@RequestMapping(value="/login/loginCheck.do", method = RequestMethod.POST)
	public String loginCheck(
			@RequestParam String user_id
			,@RequestParam String user_pass
			,@RequestParam(value="saveId", required=false) String saveId
			,HttpSession session
			,HttpServletRequest req
			,HttpServletResponse resp
			) {
		

		if("saveId".equals(saveId)) {	// 쿠키에 아이디 하루동안 저장
			Cookie savedIdCookie = new Cookie("savedId",user_id);
			savedIdCookie.setPath(String.format("%s",application.getContextPath()));
			savedIdCookie.setMaxAge(1*24*60*60);
			resp.addCookie(savedIdCookie);
		}else {	// 저장된 아이디 쿠키 삭제
			Cookie savedIdCookie = new Cookie("savedId",null);
			savedIdCookie.setPath(String.format("%s",application.getContextPath()));
			savedIdCookie.setMaxAge(0);
			resp.addCookie(savedIdCookie);
		}
		
		boolean valid = validate(user_id, user_pass);
		
		UserVO user = new UserVO();
		user.setUser_id(user_id);
		user.setUser_pass(user_pass);
		
		String view = null;
		String message = "";
		
		if(valid) {
		// 인증 (id == password)
			ServiceResult result = service.authenticate(user);
			switch(result) {
			case OK:
				// 로그인 성공시 쿠키에 접속한 아이디 저장
				Cookie idCookie = new Cookie("loginId",user.getUser_id());
				idCookie.setMaxAge(1*24*60*60);
				idCookie.setPath(String.format("%s",application.getContextPath()));
				resp.addCookie(idCookie);
				// 로그인 성공시 쿠키에 접속자 이름 저장
				Cookie nameCookie = new Cookie("loginName",user.getUser_name());
				nameCookie.setMaxAge(1*24*60*60);
				nameCookie.setPath(application.getContextPath());
				resp.addCookie(nameCookie);
				
				view = "redirect:/";
				session.setAttribute("authUser", user);
				break;
			case NOTEXIST:
				view = "redirect:/login/loginCheck.do";
				message = "아이디 오류";
				break;
			case INVALIDPASSWORD:
			default:
				// 인증 실패
				view = "redirect:/login/loginCheck.do";
				message = "비번 오류";
				break;
			}
			
		}else {
			// 1)검증
			view = "redirect:/login/loginCheck.do";
			message = "아이디나 비번 누락";
		}
		
		session.setAttribute("message", message);
		
		return view;
	}
	
	private boolean validate(String id, String pass) {
		boolean valid = true;
		valid = !(id == null || id.isEmpty() || pass==null || pass.isEmpty());
		return valid;
	}
	

}
