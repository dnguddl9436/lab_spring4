<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	StringBuilder path = new StringBuilder(request.getContextPath());
	path.append("/");
	//이전 화면[read.jsp-href:updateForm.jsp?bm_no=5]에서 값을 받아오기
	String bm_no = request.getParameter("bm_no");
	String bm_title = request.getParameter("bm_title");
	String bs_file = request.getParameter("bs_file");
	String bm_writer = request.getParameter("bm_writer");
	String bm_content = request.getParameter("bm_content");
	String bm_email = request.getParameter("bm_email");
	String bm_pw = request.getParameter("bm_pw");
	out.print(bm_no+", "+bm_writer+", "+bm_content+", "+bs_file);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/icon.css"> 
<!-- jEasyUI JS 시작 -->
<script type="text/javascript" src="<%=path.toString() %>js/jquery.min.js"></script>
<script type="text/javascript" src="<%=path.toString() %>js/jquery.easyui.min.js"></script>   
<script type="text/javascript">
</script>
</head>
<body>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#ubm_title").textbox('setValue','<%=bm_title%>');
			$("#ubm_writer").textbox('setValue','<%=bm_writer%>');
			$("#ubm_content").textbox('setValue','<%=bm_content%>');
			$("#ubm_email").textbox('setValue','<%=bm_email%>');
			$("#ubm_pw").textbox('setValue','<%=bm_pw%>');
		});
	</script>
	<!--================== [[글수정 화면]] ==================-->
	<div id="dlg_upd" title="글수정" style="width:600px;height:400px;padding:10px" data-options="footer:'#tbar_boardUpd'">	
		<form id="board_upd" method="post" action="boardUpdate.sp4">
			<input type="hidden" name="bm_no" value="<%=bm_no%>">
			<table>
				<tr>
					<td width="100px">제목</td>
					<td width="500px">
						<input class="easyui-textbox" data-options="width:'350px'" id="ubm_title" name="bm_title" required>
					</td>
				</tr>
				<tr>	
					<td width="100px">작성자</td>
					<td width="500px">
						<input class="easyui-textbox" data-options="width:'150px'" id="ubm_writer" name="bm_writer" required>
					</td>
				</tr>
				<tr>
					<td width="100px">이메일</td>
					<td width="500px">
	            		<input class="easyui-textbox" id="ubm_email" name="bm_email" data-options="prompt:'Enter a email address...',validType:'email'" style="width:100%;">
					</td>
				</tr>
				<tr>			
					<td width="100px">내용</td>
					<td width="500px">
						<input class="easyui-textbox" id="ubm_content" name="bm_content" data-options="multiline:'true',width:'400px',height:'90px'" required>
					</td>
				</tr>
				<tr>			
					<td width="100px">비번</td>
					<td width="500px">
						<input class="easyui-passwordbox" data-options="width:'100px'" id="ubm_pw" name="bm_pw" required>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 입력 화면 버튼 추가 -->
			<!-- 글수정  끝  -->	    
</body>
</html>