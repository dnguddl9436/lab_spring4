<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	StringBuilder path = new StringBuilder(request.getContextPath());
	path.append("/");
	List<Map<String,Object>> chatMsgList = null;
	chatMsgList = (List<Map<String,Object>>)request.getAttribute("enterChatroom");
	int size = 0;
	if(chatMsgList!=null) {
		size = chatMsgList.size();
	}
	out.print("chatMsgList"+chatMsgList);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>enterChatroom</title>
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/icon.css"> 
<!-- jEasyUI JS 시작 -->
<script type="text/javascript" src="<%=path.toString() %>js/jquery.min.js"></script>
<script type="text/javascript" src="<%=path.toString() %>js/jquery.easyui.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		$('#dg_board').datagrid({
			columns:[[
				{field:'sender',title:'보낸이',width:100,align:'center'},
				{field:'message',title:'마지막 메세지',width:400,align:'center'},
				{field:'timestamp',title:'보낸 시각',width:200,align:'center'},
			]]
		});
	});
</script>
</head>
<body>
	<table id="dg_board" class="easyui-datagrid" data-options="title:'게시판',toolbar:'#tb_board',width:1000,height:350" style="width:1000px;height:350px">
	  <!--   <thead>
	        <tr>
	            <th>글번호</th>
	            <th>제목</th>
	            <th>작성일</th>
	            <th>첨부파일</th>
	            <th>조회수</th>
	        </tr>
	    </thead> -->
	    <tbody>
<%
for(int i=0;i<size;i++){
	Map<String,Object> rmap = chatMsgList.get(i);
	if(i==size) break;
%>
	      	<tr>
	            <td><%=rmap.get("sender") %></td>
	            <td><%=rmap.get("message") %></td>
	            <td><%=rmap.get("timestamp") %></td>
	        </tr>
<%
}///////////////end of for
%>
	    </tbody>	
	</table>
</body>
</html>