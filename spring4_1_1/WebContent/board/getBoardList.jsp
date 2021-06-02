<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%	String str = (String)request.getAttribute("abc");
	out.println(str);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 구현 - webapp</title>
<jsp:include page="../common/commonUIglobal.jsp" flush="false"/>
</head>
<body>
	게시판 목록 페이지 입니다.
</body>
</html>