package kr.or.ddit.service;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import javax.inject.Inject;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.stereotype.Service;

import kr.or.ddit.dao.LunchDao;
import kr.or.ddit.enumpkg.ServiceResult;
import kr.or.ddit.vo.UserVO;

@Service
public class LunchServiceImpl implements LunchService{
	
	@Inject
	private LunchDao dao;

	@Override
	public ServiceResult authenticate(UserVO user) {
		UserVO savedUser = dao.selectUser(user.getUser_id());
		ServiceResult result = null;
		if(savedUser != null) {
			String inputPass = user.getUser_pass();
			try {
				String encodedPass = inputPass; // do not encrypt as column size is too small
				String savedPass = savedUser.getUser_pass();
				if(savedPass.equals(encodedPass)) {
					try {
						BeanUtils.copyProperties(user, savedUser);
					} catch (IllegalAccessException | InvocationTargetException e) {
						e.printStackTrace();
					}
					result = ServiceResult.OK;
				}else {
					result = ServiceResult.INVALIDPASSWORD;
				}
			}catch (Exception e) {
				result = ServiceResult.FAIL;
			}
		}else {
			result = ServiceResult.NOTEXIST;
		}
		return result;
	}

	@Override
	public List<UserVO> selectUserList() {
		return dao.selectUserList();
	}

	@Override
	public UserVO selectUser(String user_id) {
		return dao.selectUser(user_id);
	}


}
