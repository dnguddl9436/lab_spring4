<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript">
	function send(){
		document.f_test.submit();
	}
</script>
</head>
<body>
	<form name="f_test" action="./getBoardList.sp4" method="post">
		<input type="text" name="mem_name">
		<button onClick="send()">전송</button>
	</form>
</body>
</html>