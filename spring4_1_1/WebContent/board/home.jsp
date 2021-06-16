<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.11.2/js/all.min.js" crossorigin="anonymous" ></script>
<script src="https://code.jquery.com/jquery-3.4.1.min.js" crossorigin="anonymous" ></script>
<script type="text/javascript">
	'use strict'
    let interver = null;
	let x = 0;
	function clockAutoLoad(){
		let today = new Date();
		let hh = today.getHours().toString(); // 시
		let mm = today.getMinutes().toString();  // 분
		let ss = today.getSeconds().toString();  //초
		let getTime = (hh[1] ? hh : "0" + hh[0]) + ":" + (mm[1] ? mm : "0" + mm[0]) + ":" + (ss[1] ? ss : "0" + ss[0]);
		$('#clock').text(getTime);
	}
	function menAutoLoad(){
		if(x < 630){
		x += 70;
		let men = document.getElementById("men");
		let mar = document.getElementById("mar");
		let clock = document.getElementById("clock");
		men.style.left = x + "px";
		mar.style.left = x + "px";
		mar.style.top = 50+"px";
		clock.style.left = 20+x + "px";
		clock.style.top = 70 + "px";
		//$("#text").text(x);
		//$('#men').css('left', x);
		//$('#men1').animate({left:30}, "slow");
		}else{
			x = 0;
		}
	}
</script>
</head>
<body>
	<script type="text/javascript">
		$(document).ready(function(){
			
			function clockStart(){
				intervel = setInterval(clockAutoLoad, 1000); //3초마다 autoLoad함수 호출 - 타임라인 걸기성공
			}
			clockStart();
			
			function menStart(){
				intervel = setInterval(menAutoLoad, 1000);
			}
			menStart();
		});
	</script>
	<div class="col-lg-6">
	 	<div id="text"></div>
	      One of three columns 네번째<br>
	      <div class="container">
		      <div class="row">
		      	<div class="col-lg-12" style="height:100px;">
		      	    <img id="mar" src="../images/mar.png" style="top: 50px; width: 100px; left: 0px; bottom: 30px; position: absolute;">	
					<div id="clock" style="top: 50px; left: 90px; width: 100px; bottom: 60px; font-size: 1em; font-weight: bold; position: absolute;">&nbsp;</div>
				</div>
		      </div>	      
		      <div class="row">
			      <div class="col-lg-12">
			      <img id="men" alt="달리는 사람" src="../images/run2.gif" style="width:80px; height:100px; left: 0px; position: absolute;"/><!-- float:left; -->
			      <i class="fas fa-home" style="width:100px; height:100px; float:right;"></i>
			      </div>
		      </div>
			  <div class="row">
			      <div class="col-lg-12">
			      <table style="width:100%;">
			     	<tbody>
				      	<tr style="font-size:20px; float:center;">
				      	<td style="width:10%;">출근</td>
				      	<td style="width:10%;">1시간</td>
				      	<td style="width:10%;">2시간</td>
				      	<td style="width:10%;">3시간</td>
				      	<td style="width:10%;">4시간</td>
				      	<td style="width:10%;">5시간</td>
				      	<td style="width:10%;">6시간</td>
				      	<td style="width:10%;">7시간</td>
				      	<td style="width:20%;">퇴근(8시간)</td>
				      	</tr>
			      	</tbody>
			      </table>
			      </div>
		      </div>
	      </div>
	    </div>
	  </div>
	</div>	
</body>
</html>