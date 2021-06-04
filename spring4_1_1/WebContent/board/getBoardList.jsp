<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 구현 - webapp</title>
<jsp:include page="../common/commonUIglobal.jsp" flush="false"/>
</head>
<body>
	<table class="easyui-datagrid" data-options="title:'게시판',toolbar:'#tb_board'" style="width:500px;height:350px">
	    <thead>
	        <tr>
	            <th data-options="field:'BM_NO'">글번호</th>
	            <th data-options="field:'BM_TITLE'">제목</th>
	            <th data-options="field:'BM_DATE'">작성일</th>
	            <th data-options="field:'BS_FILE'">첨부파일</th>
	            <th data-options="field:'BM_HIT'">조회수</th>
	        </tr>
	    </thead>
	    <tbody>
	        <tr>
	            <td>001</td><td>name1</td><td>2323</td>
	        </tr>
	        <tr>
	            <td>002</td><td>name2</td><td>4612</td>
	        </tr>
	    </tbody>	
	</table>
    <div id="tb_board" style="padding:2px 5px;">
        <a href="javascript:btn_search()" class="easyui-linkbutton" iconCls="icon-search" plain="true">조회</a>
        <a href="javascript:ins()" class="easyui-linkbutton" iconCls="icon-add" plain="true">입력</a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true">수정</a>
        <a href="#" class="easyui-linkbutton" iconCls="icon-cancel" plain="true">삭제</a>
    </div>
    <script type="text/javascript">
	    function btn_search() {
		    $('.easyui-datagrid').datagrid({
		    	url: './jsonGetBoardList.sp4'
		    });
	    }
	    $(document).ready(function(){
	    	$('.easyui-datagrid').datagrid({
	    		toolbar: '#tb_board2'
	    	});
	    });
	    function ins() {
	    	$('#dlg_ins').dialog('open');
	    }
    </script>
    <!-- 글쓰기 화면 시작 -->
    <div id="dlg_ins" class="easyui-dialog" title="글쓰기" data-options="iconCls:'icon-save'" style="width:600px;height:350px;padding:10px">
        <div style="margin-bottom:20px">
            <input class="easyui-textbox" label="Email:" labelPosition="top" data-options="prompt:'Enter a email address...',validType:'email'" style="width:100%;">
        </div>
        <div style="margin-bottom:20px">
            <input class="easyui-textbox" label="First Name:" labelPosition="top" style="width:100%;">
        </div>
        <div style="margin-bottom:20px">
            <input class="easyui-textbox" label="Last Name:" labelPosition="top" style="width:100%;">
        </div>
        <div style="margin-bottom:20px">
            <input class="easyui-textbox" label="Company:" labelPosition="top" style="width:100%;">
        </div>
        
        <div>
            <a href="#" class="easyui-linkbutton" iconCls="icon-ok" style="width:100%;height:32px">Register</a>
        </div>
    </div>
    <!-- 글쓰기 화면 끝 -->
</body>
</html>