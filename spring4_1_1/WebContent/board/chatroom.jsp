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
/* width:100%;같은 %단위를 쓰려면 먼저 부모(html, body)의 속성부터 설정해줘야 한다. */
html, body {
	width: 100%;
	height: 100%;
}
/* 상대방 말풍선 */
.dest{
	font-size: 16px;
	background-color: white;
	padding: 10px;
	margin: 2px 10px 2px 10px;
	align: left;
	display:inline-block;
	border-radius: 10px 10px 10px 10px;
}
/* 자신의 말풍선 */
.me{
	font-size: 16px;
	background-color: #ffc37b;
	padding: 10px;
	margin: 2px 10px 2px 10px;
	align: right;
	display:inline-block;
	border-radius: 10px 10px 10px 10px;
}
/* 날짜변경선 */
.timeline {
	color: white;
	height: 20px;
	width: 80%;
	text-align: center;
	vertical-align: middle;
	background-color: #536a8a;
	border-radius: 10px 10px 10px 10px;
	margin: auto;
	margin-top: 20px;
	margin-bottom: 20px;
}
/* 메세지 보낸 시각 */
.timestamp {
	color: white;
	display:inline-block;
}
/* 채팅방 이름(상단) */
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
	//채팅방 고유 키
	let roomKey = "<%=request.getParameter("roomKey")%>";
	//자신의 닉네임
	let nickname = "<%=request.getParameter("nickname")%>";
	//상대방 닉네임
	let dest = "<%=request.getParameter("dest")%>";
	//날짜 비교를 위한 변수
	let prevTime = "0000-00-00";
	$(document).ready(function(){
		if(roomKey=="null") { //채팅방 고유 키를 받아오지 못하는 2가지 경우
			let checkRoom = firebase.database().ref("chatrooms").orderByChild("users/"+nickname).equalTo(true);
			checkRoom.once('value', function(snapshot){
				//1.처음 대화하는 상대라 채팅방을 새로 개설할 경우
				if(snapshot.val()==null) {
					createRoom();
				}
				//2.이미 대화한 적 있는 상대지만 채팅리스트가 아닌 제품상세페이지에서 대화하기 버튼을 눌러 채팅방을 열 경우
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
	//채팅방에 입장했을 때 UI생성
	function init(){
		$(".roomName").text(dest);
		$("title").text(dest+"님과의 채팅방");
		let reading = firebase.database().ref("chatrooms/"+roomKey+"/comments");
		reading.on('child_added', getChatMsg);
	}
	//채팅방 새로 개설
	function createRoom() {
		let newKey = firebase.database().ref("chatrooms").push().key;
		roomKey = newKey; //새로운 채팅방 고유 키 생성
		//생성한 고유 키로 테이블을 만들고 그 안에 유저 정보 저장
		let reading = firebase.database().ref("chatrooms/"+newKey+"/users");
		reading.set({
			<%=request.getParameter("nickname")%> : true,
			<%=request.getParameter("dest")%> : true
		});
		init();
	}
	//파이어베이스에 저장되어있는 채팅기록들을 불러와 보여줌
	function getChatMsg(comments){
		let msgKey = comments.key;//메세지 고유 키
		let msg = comments.val().message;//메세지 내용
		let timestamp = comments.val().timestamp;//메세지 보낸 시각
		let dayStamp = timestamp.substr(0,10);//YYYY-MM-DD
		let hourStamp = timestamp.substr(11,5);//HH:mm
		let sender = comments.val().uid;//메세지 보낸 유저의 닉네임
        let html = "";
		//날짜(하루단위)가 같지않으면 날짜변경선 생성
		if(prevTime!=dayStamp) {
			html += "<div class='timeline'>"+dayStamp+"</div>";
			prevTime = dayStamp;
		}
        if(nickname==sender) //내가 보낸 메세지일 경우
        	html += "<div align='right'><div class='timestamp'>"+hourStamp+"</div><div class='me'>"+msg+"</div></div>";
        else //상대가 보낸 메세지일 경우
        	html += "<div align='left'><div class='dest'>"+msg+"</div><div class='timestamp'>"+hourStamp+"</div></div>";
        //가져온 정보들로 구성된 메세지박스<div>를 화면에 출력
       	$(".collection").append(html);
        //스크롤을 맨 아래로 내려줌
		$('.col').scrollTop(document.querySelector(".col").scrollHeight);
	}
	//메세지 보내는 함수
	function sendMsg() {
		let msg_input = $("#input_msg").val();
		//입력한 메세지가 공백일 경우(trim()은 문자열의 앞뒤 공백을 없애주는 함수)
		if(msg_input.trim()=="")
			return;
		//메세지를 입력하고 나면 입력창 내용 지우기
		$("#input_msg").val("");
		//메세지를 파이어베이스에 저장
		let reading = firebase.database().ref("chatrooms/" + roomKey + "/comments");
		reading.push().set({
			message : msg_input,
			timestamp : getTime(),
			uid : nickname
		});
	}
	//현재 시간 구하는 함수, YYYY-MM-DD HH:mm:SS 형식으로 반환된다.
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
	//엔터키를 누르면 메세지 전송
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