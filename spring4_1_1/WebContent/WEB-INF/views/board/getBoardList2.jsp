<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	StringBuilder path = new StringBuilder(request.getContextPath());
	path.append("/");
	List<Map<String,Object>> boardList = null;
	boardList = (List<Map<String,Object>>)request.getAttribute("boardList");
	int size = 0;
	if(boardList!=null) {
		size = boardList.size();
	}
	out.print("size:"+size);
	out.print("path:"+path);
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록[WEB-INF]</title>
<!-- jEasyUI 시작 -->
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=path.toString() %>themes/icon.css"> 
<!-- jEasyUI JS 시작 -->
<script type="text/javascript" src="<%=path.toString() %>js/jquery.min.js"></script>
<script type="text/javascript" src="<%=path.toString() %>js/jquery.easyui.min.js"></script>   
<script type="text/javascript">
	function boardSel() {
		$('#dg_board').datagrid({
			url: './jsonGetBoardList.sp4',
			onLoadSuccess: function(){
				alert("조회 호출 성공");
			}
		});
	}
    function boardIns() {
    	$('#dlg_ins').dialog('open');
    }
	function boardUpd() {
		
	}
	function boardDel() {
		
	}
	function register() {
		const title = document.querySelector("#iTitle").value;
		const writer = document.querySelector("#iWriter").value;
		const email = document.querySelector("#iEmail").value;
		const content = document.querySelector("#iContent").value;
		const pw = document.querySelector("#iPw").value;
		location.href = 
				"/board/boardInsert.sp4?&bm_title="+title
						+"&bs_file=a.txt"
						+"&bm_writer="+writer
						+"&bm_email="+email
						+"&bm_content="+content
						+"&bm_pw="+pw;
	}
	function insAction() {
		console.log("입력액션 호출");
		$("#board_ins").submit();
	}
	function chatList(){
		let nickname = document.querySelector("#nickname").value;
		location.href="./getChatList.jsp?nickname="+nickname;
	}
</script>
</head>
<body>
<script type="text/javascript">
	$(document).ready(function() {
		$('#dg_board').datagrid({
			columns:[[
				{field:'BM_NO',title:'글번호',width:100,align:'center'},
				{field:'BM_TITLE',title:'제목',width:400,align:'left'},
				{field:'BM_DATE',title:'작성일',width:150,align:'center'},
				{field:'BS_FILE',title:'첨부파일',width:230,align:'center'},
				{field:'BM_HIT',title:'조회수',width:100,align:'center'},
			]],
			toolbar: '#tb_board2',
			onDblClickCell: function(index, field, value){
				if("BS_FILE" == field) {
					location.href="download.jsp?bs_file="+value;
				}
			}
		});
		$('#btn_sel').bind('click', function(){
			//alert('조회');
			boardSel();
		});
		$('#btn_ins').bind('click', function(){
			//alert('입력');
			boardIns();
		});
		$('#btn_upd').bind('click', function(){
			//alert('수정');
			boardUpd();
		});
		$('#btn_del').bind('click', function(){
			//alert('삭제');
			boardDel();
		});
	});
</script>
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
//조회 결과가 없는 거야?
if(size==0){
%>
	        <tr>
				<td colspan="5">조회결과가 없습니다.</td>
	        </tr>
<%
}
else{//조회 결과가 있는데....
	for(int i=0;i<size;i++){
		Map<String,Object> rmap = boardList.get(i);
		if(i==size) break;
%>
	      	<tr>
	            <td><%=rmap.get("BM_NO") %></td><td>
<%
	String imgPath = "\\board\\";
	if(Integer.parseInt(rmap.get("BM_POS").toString())>0){
		for(int j=0;j<Integer.parseInt(rmap.get("BM_POS").toString());j++){
			out.print("&nbsp;&nbsp;");
		}
%>
	<!-- 여기는 html 땅이다. -->
	<img src="<%=imgPath%>reply.gif" border="0">
<%
	}////////////end of if
%>
	            <a href="getBoardDetail.sp4?bm_no=<%=rmap.get("BM_NO")	%>" style="text-decoration:none;"><%=rmap.get("BM_TITLE") %></a></td>
	            <td><%=rmap.get("BM_DATE") %></td>
	            <td>
<%
	if(rmap.get("BS_FILE").toString().equals("해당없음") || rmap.get("BS_FILE")==null || rmap.get("BS_FILE").toString().length()==0) {
	}else {
%>
<a href="download.jsp?bs_file=<%=rmap.get("BS_FILE")%>" style="text-decoration:none;"><%=rmap.get("BS_FILE") %></a>
<%
	}
%>
</td>
	            <td><%=rmap.get("BM_HIT") %></td>
	        </tr>
<%
	}///////////////end of for
}///////////////////end of else
%>
	    </tbody>	
	</table>
    <div id="tb_board" style="padding:2px 5px;">
        <a id="btn_sel" href="#" class="easyui-linkbutton" iconCls="icon-search" plain="true">조회</a>
        <a id="btn_ins" href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true">입력</a>
        <a id="btn_upd" href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true">수정</a>
        <a id="btn_del" href="#" class="easyui-linkbutton" iconCls="icon-cancel" plain="true">삭제</a>
    </div>   
    <!-- 글쓰기 화면 시작 -->
    <div id="dlg_ins" class="easyui-dialog" title="글쓰기" data-options="iconCls:'icon-save',closed:'true'" style="width:600px;height:650px;padding:10px">
        <form id="board_ins" method="post" enctype="multipart/form-data" action="boardInsert.sp4">
	        <div style="margin-bottom:20px">
	            <input id="iTitle" class="easyui-textbox" name="bm_title" label="제목:" labelPosition="top" data-options="prompt:'제목'" style="width:100%;">
	        </div>
	        <div style="margin-bottom:20px">
	            <input id="iWriter" class="easyui-textbox" name="bm_writer" label="작성자:" labelPosition="top" style="width:100%;">
	        </div>
	        <div style="margin-bottom:20px">
	            <input id="iEmail" class="easyui-textbox" name="bm_email" label="이메일:" labelPosition="top" data-options="prompt:'Enter a email address...',validType:'email'" style="width:100%;">
	        </div>
	        <div style="margin-bottom:20px">
	            <input id="iContent" class="easyui-textbox" name="bm_content" label="내용:" labelPosition="top" data-options="prompt:'내용', multiline:true, width:500, height:120"style="width:100%;">
	        </div>
	        <div style="margin-bottom:20px">
	            <input id="iPw" class="easyui-passwordbox" name="bm_pw" label="비밀번호:" labelPosition="top" style="width:100%;">
	        </div>
	        <div style="margin-bottom:20px">
	            <input id="iFile" class="easyui-filebox" name="bs_file" label="첨부파일:" labelPosition="top" style="width:100%;">
	        </div>
			<div id="ft_ins">
				<a href="javascript:insAction()" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true">저장</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true">취소</a>
			</div>
		</form>
    </div>
    <input id="nickname" class="easyui-textbox" data-options="prompt:'닉네임'">
	<a href="javascript:chatList()" class="easyui-linkbutton" iconCls="icon-help" plain="true">내 채팅방 목록</a>
    <!-- 글쓰기 화면 끝 -->
</body>
</html>