package kr.or.ddit.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.ddit.vo.UserVO;

@Repository
public interface LunchDao {
	public UserVO selectUser(String user_id);
	public List<UserVO> selectUserList();
}
