package kr.or.ddit.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserVO {
	String user_id;
	String user_pass;
	String user_rating;
	String bank_no;
	String bank_user_name;
	String bank_name;
	String user_name;
}
