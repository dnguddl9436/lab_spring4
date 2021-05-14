package local.di;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class SonataApx {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		Sonata herCar = new Sonata();
		ApplicationContext context = new ClassPathXmlApplicationContext("local\\di\\sonataBean.xml");
		Sonata myCar = null;
		myCar = (Sonata)context.getBean("myCar");
		System.out.println(myCar.toString());
		Sonata yourCar = null;
		yourCar = (Sonata)context.getBean("yourCar");
		System.out.println(yourCar.toString());
		System.out.println("yourCar의 현재 속도는 "+yourCar.getSpeed());
		Sonata meCar = null;
		meCar = (Sonata)context.getBean("meCar");
		System.out.println(meCar.toString());
		System.out.println("himCar의 현재 속도는 "+meCar.getSpeed());
		Sonata himCar = null;
		himCar = (Sonata)context.getBean("himCar");
		System.out.println(himCar.toString());
		System.out.println("himCar의 현재 속도는 "+himCar.getSpeed());
	}

}
