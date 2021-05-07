package kr.or.ddit.service;

import java.util.List;

import kr.or.ddit.enumpkg.ServiceResult;
import kr.or.ddit.vo.UserVO;

public interface LunchService {
	public ServiceResult authenticate(UserVO user);
	public List<UserVO> selectUserList();
	public UserVO selectUser(String user_id);
	
}
