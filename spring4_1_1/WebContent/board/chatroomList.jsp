<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%
	request.setCharacterEncoding("UTF-8");
	StringBuilder path = new StringBuilder(request.getContextPath());
	path.append("/");
%>
<!DOCTYPE html>
<html>
<head>
<!--Import Google Icon Font-->
<link href="https://fonts.googleapis.com/icon?family=Material+Icons"
	rel="stylesheet">
<!--Import materialize.css-->
<!-- Compiled and minified CSS -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/css/materialize.min.css">


<!--Let browser know website is optimized for mobile-->
<meta charset="UTF-8"/>
<meta charset="UTF-8" name="viewport"
	content="width=device-width, initial-scale=1.0" />
<style>
::-webkit-scrollbar {
	display: none;
}

.collection {
	cursor: pointer;
}
</style>
<title>채팅방 목록</title>
</head>
<body>
      <!--Import jQuery before materialize.js-->
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.8/js/materialize.min.js"></script>
	<script type="text/javascript" src="../js/jquery.min.js"></script>
	<script type="text/javascript" src="../js/jquery.easyui.min.js"></script>
	<script defer src="https://www.gstatic.com/firebasejs/8.6.8/firebase-app.js"></script>
	<script defer src="https://www.gstatic.com/firebasejs/8.6.8/firebase-database.js"></script>
	<script defer src="./init-firebase.js"></script>
	<script type="text/javascript">
	let nickname = "<%=request.getParameter("nickname")%>";//현재 접속자의 닉네임
	let destNickname = "";//상대방의 닉네임
	let key = "";//채팅방 고유 키
	let lastMsg = "";//마지막 메세지
	let timestamp = "";//메세지 보낸 시각
	$(document).ready(function(){
		let reading = firebase.database().ref("chatrooms").orderByChild("users/"+nickname).equalTo(true);
		reading.on('child_added', test_child_added);
		reading.on('child_changed', test_child_changed);
	});
	//채팅방 목록 불러와서 화면에 보여주기 & 새로운 채팅방이 추가되는지 감시
	function test_child_added(data) {
		key = data.key;
		let userData = firebase.database().ref("chatrooms/"+key).child("users");
		let msgData = firebase.database().ref("chatrooms/"+key).child("comments").limitToLast(1);
		msgData.once('value', function(data){
			if(data.val()!=null) {
				msgData.once('child_added', getMsgData);
				userData.once('child_added', getUserData);
		        let html =
		            "<li id='"+key+"' class=\"collection-item avatar\" onclick=\"enterChatroom(this.id,'"+destNickname+"');\" >" +
		            "<i class=\"material-icons circle red\">" + destNickname.substr(0, 1) + "</i>" +
		            "<span class=\"title\">" + destNickname + "</span>" +
		            "<p class='txt'>" + lastMsg + "<br>" +
		            "</p>" +
		            "<p class='time'>" + timestamp + "<br>" +
		            "</p>" +
		            "<a href=\"#!\" onclick=\"fn_delete_data('"+key+"')\"class=\"secondary-content\"><i class=\"material-icons\">grade</i></a>"+
		            "</li>";
		        $(".collection").append(html);
			}
		});
	}
	//채팅방의 내용이 바뀌는지 감시
	function test_child_changed(data) {
		key = data.key;
		let userData = firebase.database().ref("chatrooms/"+key).child("users");
		let msgData = firebase.database().ref("chatrooms/"+key).child("comments").limitToLast(1);
		msgData.once('child_added', getMsgData);
		userData.once('child_added', getUserData);
        $("#"+key+" > .time").text(timestamp);
        $("#"+key+" > .txt").text(lastMsg);
	}
	//상대방의 닉네임을 destNickname변수에 저장
	function getUserData(data){
		if(data.key != nickname) {
			destNickname = data.key;
			console.log("destNickname = "+destNickname);
		}
	}
	//마지막 메세지의 내용과 시간을 가져옴
	function getMsgData(data){
		lastMsg = data.val().message;
		timestamp = data.val().timestamp;
		console.log("lastMsg="+lastMsg);
		console.log("timeStamp="+timestamp);
	}
	//채팅방에 입장할 때 채팅방 고유 번호, 자신의 닉네임, 상대의 닉네임을 전달
	function enterChatroom(roomKey,dest){
		$("#roomKey").val(roomKey);
		$("#nickname").val(nickname);
		$("#dest").val(dest);
		$("#destForm").submit();
	}
</script>
<body>
	<form id="destForm" action="chatroom.jsp" method="post">
		<input type="hidden" name="roomKey" id="roomKey">
		<input type="hidden" name="nickname" id="nickname">
		<input type="hidden" name="dest" id="dest">
	</form>
      <div>
        <div class="col s3" style="padding:0; margin:0; overflow-y:auto; overflow-x:hidden; height:1080px; -ms-overflow-style: none;">
          <!-- Grey navigation panel -->
          <ul class="collection"  style="padding:0; margin:0;"></ul>
        </div>

    <div class="preloader-wrapper big active" style="position:absolute; z-index:1000; left:50%; top:50%; display:none;">
        <div class="spinner-layer spinner-blue-only">
          <div class="circle-clipper left">
            <div class="circle"></div>
          </div><div class="gap-patch">
            <div class="circle"></div>
          </div><div class="circle-clipper right">
            <div class="circle"></div>
          </div>
        </div>
      </div>
  </div>
<script>
      </script>
</body>
</html>