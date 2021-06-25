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
<script defer src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
<script defer src="https://unpkg.com/@google/markerclustererplus@4.0.1/dist/markerclustererplus.min.js"></script>
<script type="text/javascript" src="<%=path.toString() %>js/jquery.min.js"></script>
<script type="text/javascript" src="<%=path.toString() %>js/jquery.easyui.min.js"></script>   
<script defer src="https://www.gstatic.com/firebasejs/8.6.8/firebase-app.js"></script>
<script defer src="https://www.gstatic.com/firebasejs/8.6.8/firebase-database.js"></script>
<script defer src="./init-firebase.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
<script type="text/javascript">
	let markerContainer = new Map();//마커들을 담을 Map타입의 변수(지도아님)
	let myMap;//지도
	let timer = setInterval(createMyMap,100);//0.1초마다 createMyMap 실행
	let riderTimer = setInterval(insertRider, 5000);//라이더 위치 갱신용 타이머(5초마다)
	let refErrand = "";//errand테이블 접근할 주소
	let refRider = "";//rider테이블 접근할 주소
	let refAlert = "";//alert테이블 접근할 주소
	let my_lat = 0.0;//현재 자신의 위도
	let my_lng = 0.0;//현재 자신의 경도
	let mem_email = "rider@email";//현재 접속자의 이메일
	let locKey = "";
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
		refErrand = firebase.database().ref("errand");
		refAlert = firebase.database().ref("alert/"+mem_email);
		refRider = firebase.database().ref("rider");
		initAlert();
 		getLoc();
//		initLoc();
//		setInterval(updateLoc,5000);
		switchRider();
	});
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
	function insAction() {
		console.log("입력액션 호출");
		$("#board_ins").submit();
	}
	
//////////////////////////////////////////채팅
	//채팅방 목록 보기
	function chatroomList(){
		let nickname = $('#nickname').val();
		if(nickname==null || nickname=="")
			alert("자신의 닉네임을 입력해주세요.");
		else
			$("#chat").submit();
	}
	
//////////////////////////////////////////common
	//현재 시간을 YYYY-MM-DD HH:mm:SS 형식으로 반환
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
	//심부름 요청자/라이더 전환(미완)
	function switchRider() {
		if ($("#switchRider").is(":checked")) {
			removeAllMarkers();
			markerContainer = new Map();
			refRider.off();
			clearInterval(riderTimer);
			console.log("라이더");
			insertRider();//자신의 위치를 rider테이블에 저장
			riderTimer = setInterval(insertRider, 5000);//5초마다 위치 갱신
			addErrand();//심부름 마커 추가 감시
			changeErrand();//심부름 마커 변경 감시
			removeErrand();//심부름 마커 삭제 감시
		} else {
			removeAllMarkers();
			markerContainer = new Map();
			refErrand.off();
			clearInterval(riderTimer);
			console.log("요청자");
			addRider();//라이더 마커 추가 감시
			changeRider();//라이더 마커 변경 감시
			removeRider();//라이더 마커 삭제 감시
		}
	}
	
//////////////////////////////////////////알림
	//alert테이블에서 사용자의 이메일로 검색,
	//해당 사용자에 대한 테이블이 없으면(처음 사용한다면) 빈 값을 넣어 테이블을 생성 
	function initAlert() {
		let findRefAlert = firebase.database().ref("alert").orderByKey().equalTo(mem_email);
		findRefAlert.once('value', function(snapshot) {
			if (snapshot.val() == null) {
				let alertData = {
					content: "",
					type: "init",
					timestamp : getTime(),
					active : 0
				};
				firebase.database().ref("alert/"+mem_email).push().update(alertData);
			}
			runAlert();
		});
	}
	//새로운 알림이 오는 것을 감지, 알림의 종류에 맞는 함수를 실행
	function runAlert() {
		let alertData = { active : 0 };
		refAlert.on('child_added',function(snapshot){
			console.log(snapshot.key);
			console.log(snapshot.val());
			let snapVal = snapshot.val();
			let type = snapshot.val().type;
			if(snapVal.active == 1) {
				if(type=="insertErrand") {
					console.log("insertErrand");
					$.messager.confirm('Comfirm', snapVal.content, function(r){
						if(r) {
							$("#dlg_agreed").dialog('close');
							refAlert.child(snapshot.key).update(alertData);//확인했으니 active를 0으로 설정
						}
					});
				}
				else if(type=="agreeErrand") {
					console.log("agreeErrand");
					$.messager.confirm('Comfirm', snapVal.content, function(r){
						if(r) {
							$("#dlg_agreed").dialog('close');
							refAlert.child(snapshot.key).update(alertData);//확인했으니 active를 0으로 설정
						}
					});
				}
				else if(type=="agreedErrand") {
					console.log("agreedErrand");
					$.messager.confirm('Comfirm', snapVal.content, function(r){
						if(r) {
							$("#dlg_agreed").dialog('close');
							refAlert.child(snapshot.key).update(alertData);//확인했으니 active를 0으로 설정
						}
					});
				}
				else if(type=="degreeErrand") {
					console.log("degreeErrand");
					$.messager.confirm('Comfirm', snapVal.content, function(r){
						if(r) {
							$("#dlg_agreed").dialog('close');
							refAlert.child(snapshot.key).update(alertData);//확인했으니 active를 0으로 설정
						}
					});
				}
				else if(type=="degreedErrand") {
					console.log("degreedErrand");
					$.messager.confirm('Comfirm', snapVal.content, function(r){
						if(r) {
							$("#dlg_agreed").dialog('close');
							refAlert.child(snapshot.key).update(alertData);//확인했으니 active를 0으로 설정
						}
					});
				}
				else if(type=="doErrand") {
					console.log("doErrand");
					$.messager.confirm('Comfirm', snapVal.content, function(r){
						if(r) {
							$("#dlg_agreed").dialog('close');
							refAlert.child(snapshot.key).update(alertData);//확인했으니 active를 0으로 설정
						}
					});
				}
				else if(type=="getErrand") {
					console.log("getErrand");
					confirmModal(snapshot.key, snapVal.errandKey, snapVal.rider);
				}
				else
					console.log("nothing");
			}
		});
	}

//////////////////////////////////////////위치
/*
	//loc테이블에서 사용자의 이메일로 검색,
	//저장된 좌표값이 있으면 해당 데이터가 있는 테이블의 key값을 locKey 전역변수에 저장
	//저장된 좌표값이 없으면(처음 사용한다면) 새로운 테이블을 만든 뒤, 그 key값을 locKey 전역변수에 저장
	function initLoc() {
		let refLoc = firebase.database().ref("loc").orderByChild("mem_email")
				.equalTo(mem_email);
		refLoc.once('value', function(snapshot) {
			if (snapshot.val() == null) {
				locKey = firebase.database().ref("loc").push().key;
				console.log("null and locKey=" + locKey);
			} else {
				refLoc.once('child_added', function(snapshot) {
					locKey = snapshot.key;
					console.log("not null and locKey=" + locKey);
				});
			}
		});
	}
	//사용자의 현재 좌표를 파이어베이스에 저장
	function updateLoc() {
		if (locKey != "") {
			getLoc();
			let locData = {
				lat : my_lat,
				lng : my_lng,
				mem_email : mem_email
			}
			firebase.database().ref("loc/" + locKey).update(locData);
		}
		console.log("locKey of updateLoc=" + locKey);
	}
*/
	//접속자의 현재 위치를 my_lat, my_lng 전역변수에 저장
	function getLoc() {
		let watchID = navigator.geolocation.watchPosition(function(position) {
			my_lat = position.coords.latitude;
			my_lng = position.coords.longitude;
			console.log(position.coords.latitude, position.coords.longitude);
		});
	}

//////////////////////////////////////////구글맵
	//구글맵api가 로드됐는지, 사용자의 현재 위치가 갱신됐는지 확인 후
	//사용자의 현재 위치 기준으로 맵 생성
	function createMyMap() {
		if (google != null && my_lat != "" && my_lng != "") {
			myMap = new google.maps.Map(document.getElementById('div_map'), {
				center : {
					lat : my_lat,
					lng : my_lng
				},
				zoom : 1,
			});
			clearInterval(timer);
		}
	}
	//받아온 심부름 정보를 가진 마커 생성
	function newErrandMarker(arr) {
		marker = new google.maps.Marker(arr);
		markerContainer.set(arr.errandKey, marker);
		console.log(markerContainer);
	}
	//받아온 라이더 정보를 가진 마커 생성
	function newRiderMarker(arr) {
		marker = new google.maps.Marker(arr);
		markerContainer.set(arr.mem_email, marker);
		console.log(markerContainer);
	}
	//마커 전부 제거
	function removeAllMarkers(){
		for(let i of markerContainer) {
			i[1].setMap(null);
		}
	}

//////////////////////////////////////////심부름요청자
	//심부름 등록 폼 열기
	function openErrForm() {
		$('#err_ins').dialog('open');
	}
	//심부름 등록 폼 닫기
	function closeErrForm() {
		$('#err_ins').dialog('close');
	}
	//심부름을 파이어베이스에 등록
	function insertErrand() {
		let reading = firebase.database().ref("errand");
		let newErrandKey = reading.push().key;
		reading.child(newErrandKey).set(
				{
					errand_item : $('#errand_item').val(),
					errand_request_date : getTime(),
					errand_item_price_req : $('#errand_item_price_req').val(),
					errand_price : $('#errand_price').val(),
					errand_total_price : $('#errand_item_price_req').val() * 1
							+ $('#errand_price').val() * 1,
					errand_content : $('#errand_content').val(),
					mem_email : $('#mem_email').val(),
					errand_lat : my_lat,
					errand_lng : my_lng,
					rider : "",
					status : 0
				});
		let alertData = {
				content : "심부름이 등록되었습니다.",
				type : "insertErrand",
				timestamp : getTime(),
				active : 0,
				errandKey : newErrandKey
		};
		refAlert.push().update(alertData);
		closeErrForm();
	}
	//심부름이 새로 추가되면 html에 심부름 정보를 적고 새로운 마커를 생성(심부름 정보를 html에 추가할 지? 마커의 속성에 다 넣을지?)
	//페이지가 로드되면서 파이어베이스의 데이터를 처음 읽어올 때 child_added로 적용된다.
	function addErrand() {
		
		refErrand
				.on(
						"child_added",
						function(childSnapshot) {
							errandData = childSnapshot.val();
							let html = "<li id='"
									+ childSnapshot.key
									+ "' onclick=\"doErrand(this.id);\" class=\"collection-item avatar\" >"
									+ "<i class=\"material-icons circle red\">"
									+ errandData.mem_email.substr(0, 1)
									+ "</i>"
									+ "<span class=\"title\">"
									+ errandData.mem_email
									+ "</span>"
									+ "<p class='txt'>"
									+ errandData.errand_item
									+ "<br>"
									+ "</p>"
									+ "<p class='time'>"
									+ errandData.errand_content
									+ "<br>"
									+ "</p>"
									+ "<a href=\"#!\" class=\"secondary-content\"><i class=\"material-icons\">grade</i></a>"
									+ "</li>";
							$(".collection").append(html);
							let arr = {
								position : {
									lat : errandData.errand_lat,
									lng : errandData.errand_lng
								},
								map : myMap,
								errandKey : childSnapshot.key
							};
							let marker = null;
							newErrandMarker(arr);
						});
	}
	//심부름의 상태가 변경되면(누군가 이미 이 심부름을 배달하겠다고 요청중이면) 마커를 변경해야함(미완)
	function changeErrand() {
		refErrand.on("child_changed", function(childSnapshot) {
			errandData = childSnapshot.val();
			markerContainer.get(childSnapshot.key).setPosition(
					new google.maps.LatLng(errandData.errand_lat,
							errandData.errand_lng));
		});
	}
 	//심부름이 삭제되면 지도에서 해당 마커도 삭제
	function removeErrand() {
		refErrand.on("child_removed", function(childSnapshot) {
			markerContainer.get(childSnapshot.key).setMap(null);
		});
	}
	//라이더가 심부름 하겠다는 버튼을 눌렀을 때 요청자에게 띄우는 모달창
 	function confirmModal(alertKey, errandKey, rider) {
		$.messager.confirm('Comfirm', rider + "님이 배달을 희망합니다. 수락하시겠습니까?", function(r){
			if(r) {
				agreeErrand(errandKey, rider);
			}
			else {
				degreeErrand(errandKey, rider);
			}
			$("#dlg_confirmModal").dialog('close');
			let alertData = { active : 0 };
			refAlert.child(alertKey).update(alertData);
		});
	}
	//수락할 시 status를 1로 설정
	function agreeErrand(errandKey, rider) {
		refErrand.child(errandKey).once('value', function(snapshot){
			let alertData = {
					content : snapshot.val().errand_item+" 심부름 배달 요청이 수락되었습니다. 심부름을 시작하세요!",
					type : "agreedErrand",
					timestamp : getTime(),
					active : 1,
					errandKey : errandKey,
					requester : mem_email
			};
			firebase.database().ref("alert/"+rider).push().update(alertData);
			alertData = {
					content : snapshot.val().errand_item+" 심부름 배달 요청을 수락하셨습니다. 심부름이 시작됩니다!",
					type : "agreeErrand",
					timestamp : getTime(),
					active : 1,
					errandKey : errandKey,
					rider : rider
			};
			refAlert.push().update(alertData);
			let updData = {
				status : 1
			};
			refErrand.child(errandKey).update(updData);
		});
	}
	//거부할 시 rider를 ""로 설정
	function degreeErrand(errandKey, rider) {
		refErrand.child(errandKey).once('value', function(snapshot){
			let alertData = {
					content : snapshot.val().errand_item+" 심부름 배달 요청이 거절되었습니다.",
					type : "degreedErrand",
					timestamp : getTime(),
					active : 1
			};
			firebase.database().ref("alert/"+rider).push().update(alertData);
			alertData = {
					content : snapshot.val().errand_item+" 심부름 배달 요청을 거절하셨습니다.",
					type : "degreeErrand",
					timestamp : getTime(),
					active : 1
			};
			refAlert.push().update(alertData);
			let updData = {
				rider : ""
			};
			refErrand.child(errandKey).update(updData);
		});
	}

//////////////////////////////////////////라이더
	//rider테이블에서 사용자의 이메일로 검색,
	//해당 사용자에 대한 테이블이 없으면(처음 사용한다면) 값을 넣어 테이블을 생성
	function insertRider() {
		getLoc();
		let riderData = {
			lat : my_lat,
			lng : my_lng,
			//mem_email : mem_email,
			timestamp : getTime()
		};
		refRider.child(mem_email).update(riderData);
		console.log(mem_email+" rider loc updated. lat="+my_lat+" lng="+my_lng);
	}
	//파이어베이스에 저장된 라이더들의 위치를 마커로 표시 & 추가될 때 마다 마커 추가
	function addRider() {
		refRider.on("child_added", function(childSnapshot) {
			riderData = childSnapshot.val();
			let arr = {
				position : {
					lat : riderData.lat,
					lng : riderData.lng
				},
				map : myMap,
				mem_email : childSnapshot.key
			};
			let marker = null;
			newRiderMarker(arr);
		});
	}
	//라이더의 위치가 변경되면 마커의 위치도 변경
	function changeRider() {
		refRider.on("child_changed", function(childSnapshot) {
			riderData = childSnapshot.val();
			markerContainer.get(childSnapshot.key).setPosition(
					new google.maps.LatLng(riderData.lat,
							riderData.lng));
		});
	}
	//심부름이 삭제되면 지도에서 해당 마커도 삭제
	function removeRider() {
		refRider.on("child_removed", function(childSnapshot) {
			markerContainer.get(childSnapshot.key).setMap(null);
		});
	}
	//라이더가 심부름 하겠다는 버튼을 눌렀을 때 심부름 테이블 rider 속성 변경
	function doErrand(errandKey) {
		let riderEmail = { rider : mem_email };
		let observeRider = firebase.database().ref("errand/" + errandKey);
		observeRider.update(riderEmail);
		observeRider.once('value', function(snapshot){
			//라이더의 알림 추가
			let alertData = {
					content : snapshot.val().errand_item+" 심부름 배달 요청을 보냈습니다.",
					type : "doErrand",
					timestamp : getTime(),
					active : 1,
					errandKey : errandKey
			};
			refAlert.push().update(alertData);
			//심부름 요청자의 알림 추가
			alertData = {
					content : snapshot.val().errand_item+" 심부름을 희망하는 라이더가 있습니다.",
					type : "getErrand",
					timestamp : getTime(),
					active : 1,
					rider : mem_email,
					errandKey : errandKey
			};
			firebase.database().ref("alert/"+snapshot.val().mem_email).push().update(alertData);
		});
	}
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
	<div id="div_map" style="width:1000px; height:1000px;"></div>
	    <script
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyC4pd9w90oFRuCZOILRd07MBwVAthwIbIA&callback=initMap&region=kr"
    async></script>
    <script src="main.js"></script>
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
    <input type="checkbox" id="switchRider" onclick="switchRider()" checked><label for="switchRider">요청자/라이더 전환</label>
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
			<a href="javascript:insertErrand()" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true">저장</a>
			<a href="javascript:closeErrForm()" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true">취소</a>
		</div>
    </div>
	<a href="javascript:openErrForm()" class="easyui-linkbutton" iconCls="icon-help" plain="true">심부름 등록</a>

    <ul class="collection"  style="padding:0; margin:0;"></ul>
    <!-- 글쓰기 화면 끝 -->
	<div id="dlg_confirmModal" title="배달 수락/거절" class="easyui-dialog" style="width:600px;height:400px;padding:10px" data-options="closed:'true',modal:'true'">
	</div>	
	<div id="dlg_agreed" title="배달 수락됨" class="easyui-dialog" style="width:600px;height:400px;padding:10px" data-options="closed:'true',modal:'true'">
	</div>	
</body>
</html>