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
	/* display: none; */
}
html, body {
	width: 100%;
	height: 100%;
}
.dest{
	font-size: 16px;
	background-color: white;
	padding: 10px;
	margin: 0 10px 0 10px;
	align: left;
	display:inline-block;
	border-radius: 10px 10px 10px 10px;
}
.me{
	font-size: 16px;
	background-color: #ffc37b;
	padding: 10px;
	margin: 0 10px 0 10px;
	align: right;
	display:inline-block;
	border-radius: 10px 10px 10px 10px;
}
.divchat {
	height: 2px;
}
.timeline {
	color: white;
	height: 20px;
	width: 80%;
	text-align: center;
	vertical-align: middle;
	background-color: #536a8a;
	border-radius: 10px 10px 10px 10px;
	margin: auto;
}
.timestamp {
	color: white;
	display:inline-block;
}
.roomName {
	color: white;
	font-size: 36px;
	background-color: #536a8a;
	display: fixed;
}
</style>
<title></title>
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
	let roomKey = "<%=request.getParameter("roomKey")%>";
	let nickname = "<%=request.getParameter("nickname")%>";
	let dest = "<%=request.getParameter("dest")%>";
	let prevTime = "0000-00-00";
	$(document).ready(function(){
		if(roomKey=="null") {
			let checkRoom = firebase.database().ref("chatrooms").orderByChild("users/"+nickname).equalTo(true);
			checkRoom.once('value', function(snapshot){
				if(snapshot.val()==null) {
					createRoom();
				}
				else {
					let reading = firebase.database().ref("chatrooms").orderByChild("users/"+nickname).equalTo(true);
					reading.once('child_added',function(snapshot){
						roomKey = snapshot.key;
						init();
					});
				}
			});
		}
		else
			init();
	});
	function init(){
		$(".roomName").text(dest);
		$("title").text(dest+"님과의 채팅방");
		let reading = firebase.database().ref("chatrooms/"+roomKey+"/comments");
		reading.on('child_added', getChatMsg);
	}
	function createRoom() {
		let newKey = firebase.database().ref("chatrooms").push().key;
		roomKey = newKey;
		let reading = firebase.database().ref("chatrooms/"+newKey+"/users");
		reading.set({
			<%=request.getParameter("nickname")%> : true,
			<%=request.getParameter("dest")%> : true
		});
		init();
	}
	function getChatMsg(comments){
		let msgKey = comments.key;
		let msg = comments.val().message;
		let timestamp = comments.val().timestamp;
		let dayStamp = timestamp.substr(0,10);
		let hourStamp = timestamp.substr(11,5);
		let sender = comments.val().uid;
        let html = "<div class='divchat'></div>";
		if(prevTime!=dayStamp) {
			html += "<div style='height:18px;'></div>";
			html += "<div class='timeline'>"+dayStamp+"</div>";
			html += "<div style='height:20px;'></div>";
			prevTime = dayStamp;
		}
        if(nickname==sender)
        	html += "<div align='right'><div class='timestamp'>"+hourStamp+"</div><div class='me'>"+msg+"</div></div>";
        else
        	html += "<div align='left'><div class='dest'>"+msg+"</div><div class='timestamp'>"+hourStamp+"</div></div>";
        html += "<div class='divchat'></div>";
        $(".collection").append(html);
		$('.col').scrollTop(document.querySelector(".col").scrollHeight);
	}
	function sendMsg() {
		let msg_input = $("#input_msg").val();
		$("#input_msg").val("");
		let reading = firebase.database().ref("chatrooms/" + roomKey + "/comments");
		reading.push().set({
			message : msg_input,
			timestamp : getTime(),
			uid : nickname
		});
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
	function enterkey(){
		if (window.event.keyCode == 13) {
			sendMsg();
       }
	}
	</script>
<body>
    <div style="width:100%; height:100%;">
        <div class="col s3" style="background-color: #627ea4; padding:0; margin:0; overflow-y:auto; overflow-x:hidden; height:90%; -ms-overflow-style: none;">
          <div class="roomName">상대방</div>
          <div class="divchat"></div>
          <!-- insert here : 대화 공지사항 -->
          <ul class="collection"  style="padding:0; margin:0; border:none;"></ul>
        </div>
    <div align="center" style="background-color: white; height:10%;"><input id="input_msg" onkeyup="enterkey();" style="width:80%; padding:10px;"><button id="btn_msg" style="width:10%;" onClick="sendMsg()">전송</button></div>

  </div>
<script>
      </script>
</body>
</html>