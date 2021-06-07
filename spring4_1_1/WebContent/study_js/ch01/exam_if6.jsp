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
      let x = 10;
      let y = 5;
      var result = x>y ? "javascript":"hello";
      document.write(result);
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