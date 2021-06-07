<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/common/commonUIglobal.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <script type="text/javascript">
	  function test() {
		  if(1!=1) {
		    document.write("같다.","<br>");
		  }
		  else {
		    document.write("다르다.");
		  }
	  }
  </script>
</head>
<body>
  여기
 <script type="text/javascript">test();</script>
 <br>
  저기
</body>
</html>