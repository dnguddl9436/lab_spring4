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
      let site = prompt('네이버, 다음, 구글 중 자주 이용하는 사이트는?');
      let url;
      switch(site) {
        case "네이버":
          url="https://naver.com";
          break;
        case "다음":
          url="https://daum.net";
          break;
        case "구글":
          url="https://google.com";
          break;
        default:
          url="http://localhost:9000/spring4_1_1/study_js/ch01/exam_switch.jsp"
      }
      if(url) {
        location.href=url;
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