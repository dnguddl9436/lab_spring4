// Nullish coalescing operator - 널 병합 연산자
https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/Nullish_coalescing_operator
{
  {
    const name = 'scott';
    const userName = name || 'Guest';
    console.log(userName);
  }
  {
    const name = null;
    const userName = name || 'Guest';
    console.log(userName);
  }
  {
    const name = '';
    const userName = name || 'Guest';
    console.log(userName);
  }
  {
    const num = null;
    const message = num || 'undefined';
    console.log(message);
  }
  // 문제 해결 구간
  {
    const name = '';
    const userName = name ?? 'Guest';
    console.log(`봐 난 달라 ==> ${userName}<==입니다`);
  }
  {
    const num = null;
    const message = num ?? 'undefined';
    console.log(`날[??] 저기[||]랑 비교하지 마!!! ==> ${message}<==입니다`);
  }
}