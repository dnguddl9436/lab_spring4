package local.di;

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
}
