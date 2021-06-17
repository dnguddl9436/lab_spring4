<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	StringBuilder path = new StringBuilder(request.getContextPath());
	path.append("/");
	String bm_no = request.getParameter("bm_no");
	String bs_file = request.getParameter("bs_file");
	String bm_writer = request.getParameter("bm_writer");
	String bm_content = request.getParameter("bm_content");
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
	function updAction() {
		console.log("입력액션 호출");
		$("#board_upd").submit();
	}
</script>
</head>
<body>

	<!--================== [[글수정 화면]] ==================-->
	<div id="dlg_upd" title="글수정" style="width:600px;height:400px;padding:10px" data-options="footer:'#tbar_boardUpd'">	
		<form id="board_upd" method="post" action="boardUpdate.sp4">
			<input type="hidden" name="bm_no" value="<%=bm_no%>">
			<table>
				<tr>
					<td width="100px">제목</td>
					<td width="500px">
						<input class="easyui-textbox" data-options="width:'350px'" id="bm_title" name="bm_title" required>
					</td>
				</tr>
				<tr>	
					<td width="100px">작성자</td>
					<td width="500px">
						<input class="easyui-textbox" data-options="width:'150px'" id="bm_writer" name="bm_writer" required>
					</td>
				</tr>
				<tr>
					<td width="100px">이메일</td>
					<td width="500px">
	            		<input class="easyui-textbox" id="bm_email" name="bm_email" data-options="prompt:'Enter a email address...',validType:'email'" style="width:100%;">
					</td>
				</tr>
				<tr>			
					<td width="100px">내용</td>
					<td width="500px">
						<input class="easyui-textbox" id="bm_content" name="bm_content" data-options="multiline:'true',width:'400px',height:'90px'" required>
					</td>
				</tr>
				<tr>			
					<td width="100px">비번</td>
					<td width="500px">
						<input class="easyui-passwordbox" data-options="width:'100px'" id="bm_pw" name="bm_pw" required>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 입력 화면 버튼 추가 -->
	<div id="tbar_boardUpd" align="right">
		<a href="javascript:updAction()" class="easyui-linkbutton" iconCls="icon-save">수정</a>
		<a href="javascript:$('#dlg_upd').dialog('close')" class="easyui-linkbutton" iconCls="icon-cancel">닫기</a>
	</div>
			<!-- 글수정  끝  -->	    
</body>
</html>