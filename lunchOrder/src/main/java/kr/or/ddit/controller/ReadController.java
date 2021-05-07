package kr.or.ddit.controller;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.ddit.service.LunchService;

@Controller
public class ReadController {
	
	@Inject
	private LunchService service;
	
	@RequestMapping("/test")
	public String testController(
			Model model
			) {
		String test = service.test();
		model.addAttribute("test",test);
		
		return "test";
	}
	
	@RequestMapping("/login")
	public String loginController(
			) {
		
		return "login";
	}

}
