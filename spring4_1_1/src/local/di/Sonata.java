package local.di;

//import org.springframework.context.annotation.Scope;

//@Scope("singleton")
public class Sonata {
	private String carColor = null;
	private int wheelNum = 0;
	private int speed = 0;
	public Sonata() {}
	public Sonata(String carColor, int wheelNum) {
		this.carColor = carColor;
		this.wheelNum = wheelNum;
	}
	public Sonata(String carColor, int wheelNum, int speed) {
		this.carColor = carColor;
		this.wheelNum = wheelNum;
		this.speed = speed;
	}
	@Override
	public String toString() {
		return "자동차 정보 출력하기";
	}
	public String getCarColor() {
		return carColor;
	}
	public void setCarColor(String carColor) {
		this.carColor = carColor;
	}
	public int getWheelNum() {
		return wheelNum;
	}
	public void setWheelNum(int wheelNum) {
		this.wheelNum = wheelNum;
	}
	public int getSpeed() {
		return speed;
	}
	public void setSpeed(int speed) {
		this.speed = speed;
	}
}
