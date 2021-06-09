// Optional Chaining
https://developer.mozilla.org/ko/docs/Web/JavaScript/Reference/Operators/Optional_chaining
{
  const worker1 = {
    name: 'Scott',
    job: {
      title: 'Front Engineer',
      manager: {
        name: 'King',
      },
    }
  };
  const worker2 = {
    name: 'King',
  };
  {
    function print(worker){
      console.log(worker.job && worker.job.manager && worker.job.manager.name);
    }
    print(worker1);
    print(worker2);
  }
  {
    function print(worker){
      console.log(worker.job
                  ? worker.job.manager
                    ? worker.job.manager.name
                    :undefined
                  :undefined
                  );
    }
    print(worker1);
    print(worker2);
  }
  {//추천
    function print(worker){
      console.log(worker.job?.manager?.name);
    }
    print(worker1);
    print(worker2);
  }
}