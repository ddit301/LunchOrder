<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<link rel="stylesheet" href="loginjs/bootstrap-4.6.0-dist/css/bootstrap.min.css">

<script type=text/javascript src="loginjs/jquery-3.6.0.min.js"></script>
<script type=text/javascript src="loginjs/myJqueryPlugin.js"></script>
<script type=text/javascript src="loginjs/jquery.form.min.js"></script>
<script type="text/javascript">
	$.getContextPath = function(){
		return "${cPath }";
	}
</script>