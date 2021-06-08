// 즉시 실행 함수
/*
  (function(){
    자바스크립트 코드;
  }());
*/
{
  /*
  (function () {
    let num = 100;
    function menu() {
      num += 100;
      alert(num);
      //console.log(num);
    }
    menu();
  }());
  */ 
  //개발자 A와 B가 즉시 실행 함수에 지역변수와 지역함수를 선언하여 충돌을 방지함.
  (function(){
    let num = 100;
    function menu(){
      alert(`num ${num}`);
    }
    menu();
  }());
}