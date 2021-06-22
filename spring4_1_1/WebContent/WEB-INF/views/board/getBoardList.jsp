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
<script defer src="https://www.gstatic.com/firebasejs/8.6.8/firebase-app.js"></script>
<script defer src="https://www.gstatic.com/firebasejs/8.6.8/firebase-database.js"></script>
<script defer src="./init-firebase.js"></script>
<script type="text/javascript">
	let my_lat = 0.0;
	let my_lon = 0.0;
	let mem_email = "test@email";
	let locKey = "";
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
	function chatroomList(){
		let nickname = $('#nickname').val();
		if(nickname==null || nickname=="")
			alert("자신의 닉네임을 입력해주세요.");
		else
			$("#chat").submit();
	}
    function openErrForm() {
    	$('#err_ins').dialog('open');
    }
    function closeErrForm() {
    	$('#err_ins').dialog('close');
    }
    function getTime(){
		let today = new Date();

		let year = today.getFullYear();
		let month = ('0' + (today.getMonth() + 1)).slice(-2);
		let day = ('0' + today.getDate()).slice(-2);

		let hours = ('0' + today.getHours()).slice(-2); 
		let minutes = ('0' + today.getMinutes()).slice(-2);
		let seconds = ('0' + today.getSeconds()).slice(-2); 

		let dateString = year + '-' + month  + '-' + day;
		let timeString = hours + ':' + minutes  + ':' + seconds;
		let rstTime = dateString+" "+timeString;
		return rstTime;
	}
    function getLoc(){
        let watchID = navigator
        .geolocation
        .watchPosition(function(position) {
        	my_lat = position.coords.latitude;
        	my_lon = position.coords.longitude;
            console.log(position.coords.latitude, position.coords.longitude);
        });
    }
    function insertErr() {
		let reading = firebase.database().ref("errand");
		reading.push().set({
			errand_item : $('#errand_item').val(),
			errand_request_date : getTime(),
			errand_item_price_req : $('#errand_item_price_req').val(),
			errand_price : $('#errand_price').val(),
			errand_total_price : $('#errand_item_price_req').val()*1+$('#errand_price').val()*1,
			errand_content : $('#errand_content').val(),
			mem_email : $('#mem_email').val(),
			errand_lat : my_lat,
			errand_lon : my_lon,
			rider_email : "",
			status : "W" 
		});
    }
    function initLoc() {
		let refLoc = firebase.database().ref("loc").orderByChild("mem_email").equalTo(mem_email);
		refLoc.once('value', function(snapshot){
			if(snapshot.val()==null) {
				locKey = firebase.database().ref("loc").push().key;
				console.log("null and locKey="+locKey);
			}
			else {
				refLoc.once('child_added',function(snapshot){
					locKey = snapshot.key;
					console.log("not null and locKey="+locKey);
				});
			}
		});
    }
    function updateLoc() {
    	if(locKey != "") {
        	getLoc();
	    	let locData = {
	    		lat : my_lat,
	    		lon : my_lon,
	    		mem_email : mem_email
	    	}
	    	firebase.database().ref("loc/"+locKey).update(locData);
    	}
    	console.log("locKey of updateLoc="+locKey);
    }
    function showErrand(){
    	let reading = firebase.database().ref("errand");
    	reading.on("value", function(snapshot){
    		snapshot.forEach(function(childSnapshot) {
    			errandData = childSnapshot.val();
	            let html =
	                "<li id='"+childSnapshot.key+"' class=\"collection-item avatar\" onclick=\"chooseErrand(this.id);\" >" +
	                "<i class=\"material-icons circle red\">" + errandData.mem_nickname.substr(0, 1) + "</i>" +
	                "<span class=\"title\">" + errandData.mem_nickname + "</span>" +
	                "<p class='txt'>" + errandData.errand_item + "<br>" +
	                "</p>" +
	                "<p class='time'>" + errandData.errand_content + "<br>" +
	                "</p>" +
	                "<a href=\"#!\" onclick=\"fn_delete_data('"+childSnapshot.key+"')\"class=\"secondary-content\"><i class=\"material-icons\">grade</i></a>"+
	                "</li>";
	            $(".collection").append(html);
    		});
	    });
    }
    //라이더가 심부름 하겠다는 버튼을 눌렀을 때 심부름 테이블 rider 속성 변경
    function doErrand(errandKey){
		let nickname = {
				rider : $('#nickname').val()
		}
    	firebase.database().ref("errand/"+errandKey).update(nickname);
		//아래는 라이더입장에서 요청자가 수락하는지 감시하는 코드
    	let observeRider = firebase.database().ref("errand/"+errandKey);
		observeRider.on('value', function(snapshot){
    		if(snapshot.val().rider==""){
    			console.log("거절당하셨습니다.")
    			observeRider.off();
    		}
    		else if()
    	});
    }
    //자신이 요청한 심부름 테이블을 감시하다가 라이더가 배달한다고 하면 감지
    function observe(){
		let refErr = firebase.database().ref("errand").orderByChild("mem_email").equalTo(mem_email);
		refErr.on('value',function(snapshot){
			refErr.forEach(function(childSnapshot){
				if(rider!="") {
					confirmModal(childSnapshot.key);
				}
			});
		});
    }
    //라이더가 심부름 하겠다는 버튼을 눌렀을 때 요청자에게 띄우는 모달창
    function confirmModal(errandKey){
    	console.log("해당 라이더를 승낙하시겠어요?");
    	//승낙할 시
    	agreeErrand(errandKey);
    	//거부할 시
    	degreeErrand(errandKey);
    }
    //승낙할 시
    function agreeErrand(errandKey){
    	
    }
    //거부할 시
    function degreeErrand(errandKey){
    	
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
		getLoc();
		initLoc();
		setInterval(updateLoc,1000);
		showErrand();
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
    <form id="chat" action="chatroomList.jsp" method="post">
    <input id="nickname" name="nickname" class="easyui-textbox" data-options="prompt:'닉네임'">
	<a href="javascript:chatroomList()" class="easyui-linkbutton" iconCls="icon-help" plain="true">내 채팅방 목록</a>
    </form>
    <div id="err_ins" class="easyui-dialog" title="심부름 등록" data-options="iconCls:'icon-save',closed:'true'" style="width:600px;height:650px;padding:10px">
        <div style="margin-bottom:20px">
            <input id="errand_item" class="easyui-textbox" label="심부름 물건:" labelPosition="top" style="width:100%;">
        </div>
        <div style="margin-bottom:20px">
            <input id="errand_item_price_req" class="easyui-textbox" label="심부름 물건 가격:" labelPosition="top" style="width:100%;">
        </div>
        <div style="margin-bottom:20px">
            <input id="errand_price" class="easyui-textbox" label="심부름값:" labelPosition="top" style="width:100%;">
        </div>
        <div style="margin-bottom:20px">
            <input id="errand_content" class="easyui-textbox" label="심부름 내용:" labelPosition="top" style="width:100%;">
        </div>
        <div style="margin-bottom:20px">
            <input id="mem_email" class="easyui-textbox" label="닉네임:" labelPosition="top" style="width:100%;">
        </div>
		<div id="ft_ins">
			<a href="javascript:insertErr()" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true">저장</a>
			<a href="javascript:closeErrForm()" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true">취소</a>
		</div>
    </div>
	<a href="javascript:openErrForm()" class="easyui-linkbutton" iconCls="icon-help" plain="true">심부름 등록</a>

    <ul class="collection"  style="padding:0; margin:0;"></ul>
    <!-- 글쓰기 화면 끝 -->
</body>
</html>