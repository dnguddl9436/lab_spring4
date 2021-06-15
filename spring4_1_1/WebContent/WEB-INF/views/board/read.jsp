<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	StringBuilder path = new StringBuilder(request.getContextPath());
	path.append("/");
	List<Map<String,Object>> boardDetail = null;
	boardDetail = (List<Map<String,Object>>)request.getAttribute("boardDetail");
	int size = 0;
	String bm_email 	= null;
	String bm_file 		= null;
	String bm_title 	= null;
	String bm_writer 	= null;
	String bm_content 	= null;
	String bm_pw 		= null;
	String bm_no 		= null;
	String bm_group 	= null;
	String bm_pos 		= null;
	String bm_step 		= null;
	if(boardDetail!=null) {
		size = boardDetail.size();
		bm_email = boardDetail.get(0).get("BM_EMAIL").toString();
		bm_file = boardDetail.get(0).get("BS_FILE").toString();
		bm_title = boardDetail.get(0).get("BM_TITLE").toString();
		bm_writer = boardDetail.get(0).get("BM_WRITER").toString();
		bm_content = boardDetail.get(0).get("BM_CONTENT").toString();
		bm_pw = boardDetail.get(0).get("BM_PW").toString();
		bm_no = boardDetail.get(0).get("BM_NO").toString();
		bm_group = boardDetail.get(0).get("BM_GROUP").toString();
		bm_pos = boardDetail.get(0).get("BM_POS").toString();
		bm_step = boardDetail.get(0).get("BM_STEP").toString();
	}   
	out.print("size:"+size);
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
	//댓글쓰기
	function repleForm(){
		$("#dlg_boardAdd").dialog('open');
	}
	function boardList(){
		location.href="./getBoardList.sp4";
	}
	function addAction(){
		const title = document.querySelector("#bm_title").value;
		const writer = document.querySelector("#bm_writer").value;
		const email = document.querySelector("#bm_email").value;
		const content = document.querySelector("#bm_content").value;
		const pw = document.querySelector("#bm_pw").value;
		location.href = 
			"/board/boardInsert.sp4?&bm_title="+title
					+"&bm_no="+no
					//+"&bs_file=a.txt"
					+"&bm_writer="+writer
					+"&bm_email="+email
					+"&bm_content="+content
					+"&bm_pw="+pw
					+"&bm_group="+group
					+"&bm_pos="+pos
					+"&bm_step="+step;
	}
</script>
</head>
<body>
    <table align="center" id="p" class="easyui-panel" title="글상세보기" data-options="footer:'#tb_read'"
        style="width:670px;height:380px;padding:10px;background:#fafafa;">
	    	<tr>
	    	<td>제목</td>
	    	<td><input id="bm_title" value="<%=bm_title%>" name="bm_title" data-options="width:'450px'" class="easyui-textbox"></td>
	    	</tr>
	    	<tr>
	    	<td>작성자</td>
	    	<td><input id="bm_writer" value="<%=bm_writer%>" name="bm_writer" class="easyui-textbox"></td>
	    	</tr>
	    	<tr>
	    	<td>이메일</td>
	    	<td><input id="bm_email" value="<%=bm_email%>" name="bm_email" class="easyui-textbox"></td>
	    	</tr>
	    	<tr>
	    	<td>내용</td>
	    	<td><input id="bm_content" value="<%=bm_content%>" name="bm_content" data-options="multiline:'true', width:'570px', height:'90px'" class="easyui-textbox"></td>
	    	</tr>
	    	<tr>
	    	<td>비밀번호</td>
	    	<td><input id="bm_pw" value="<%=bm_pw%>" name="bm_pw" class="easyui-passwordbox"></td>
	    	</tr>	    	
	   </table>
	 <div id="tb_read" style="padding:2px 5px;" align="center">
	    <a href="javascript:repleForm()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">댓글쓰기</a>
	    <a href="javascript:updateForm()" class="easyui-linkbutton" iconCls="icon-add" plain="true">수정</a>
	    <a href="javascript:boardDelView()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">삭제</a>
	    <a href="javascript:boardList()" class="easyui-linkbutton" iconCls="icon-search" plain="true">목록</a>
	</div>
	<!--================== [[댓글쓰기 화면]] ==================-->
	<div id="dlg_boardAdd" title="댓글쓰기" class="easyui-dialog" style="width:600px;height:400px;padding:10px" data-options="closed:'true',modal:'true',footer:'#tbar_boardAdd'">	
	<!-- 
	form전송시 encType옵션이 추가되면 request객체로 사용자가 입력한 값을 꺼낼 수 없다.
	MultipartRequest  => cos.jar
	 -->	
		<form id="f_boardAdd" method="get">
		<input type="hidden" name="bm_no" value="<%=bm_no%>">
		<input type="hidden" name="bm_group" value="<%=bm_group%>">
		<input type="hidden" name="bm_pos" value="<%=bm_pos%>">
		<input type="hidden" name="bm_step" value="<%=bm_step%>">
		<!-- <form id="f_boardAdd"> -->
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
					<input class="easyui-textbox" data-options="width:'250px'" id="bm_email" name="bm_email">
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
					<input class="easyui-textbox" data-options="width:'100px'" id="bm_pw" name="bm_pw" required>
				</td>
			</tr>
		</table>
		</form>
	</div>
	<!-- 입력 화면 버튼 추가 -->
	<div id="tbar_boardAdd" align="right">
		<a href="javascript:addAction()" class="easyui-linkbutton" iconCls="icon-save">저장</a>
		<a href="javascript:$('#dlg_boardAdd').dialog('close')" 
		   class="easyui-linkbutton" iconCls="icon-cancel">닫기</a>
	</div>
			<!-- 댓글쓰기  끝  -->	    
</body>
</html>