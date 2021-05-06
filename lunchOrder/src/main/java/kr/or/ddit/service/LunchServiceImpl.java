package kr.or.ddit.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import kr.or.ddit.dao.LunchDao;

@Service
public class LunchServiceImpl implements LunchService{
	
	@Inject
	private LunchDao dao;

	@Override
	public String test() {
		return dao.al_id();
	}

}
