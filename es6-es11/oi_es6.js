// Object Initializer
https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/Object_initializer
{
  const person = {
    name: 'scott',
    age: '35'
  };

  const name = 'scott';
  const age = '35';

  const person2 = {
    name: name,
    age: age
  };
  
  const person3 = {
    name,
    age
  };

  const person4 = {
    func: function(){
      console.log("function test");
    }
  };

  console.log(person, person2, person3);
  person4.func();
}