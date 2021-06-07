<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<script type="text/javascript">
	const d = new Array();
	d[0] = 30;
	d[1] = "따릉이";
	d[2] = true;
	const d2 = new Array(50,"노트북",false);
	const d3 = [70,"핸드폰",true];
	for(var i = 0; i < d.length; i++)
		document.write(d[i]);
	document.write("<br>");
	for(var i = 0; i < d2.length; i++)
		document.write(d2[i]);
	document.write("<br>");
	for(var i = 0; i < d3.length; i++)
		document.write(d3[i]);
	document.write("<br>");
</script>
</body>
</html>