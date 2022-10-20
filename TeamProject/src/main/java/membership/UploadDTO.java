package membership;

public class UploadDTO {
	private String lat;
	private String lng;
	private String memo;
	private String date;
	private int num;
	private String title;
	private String id;
	private int count;
	
	public String getLatitude() {
		return lat;
	}
	public void setLatitude(String latitude) {
		lat = latitude;
	}
	public String getLongitude() {
		return lng;
	}
	public void setLongitude(String longitude) {
		this.lng = longitude;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	
	
	
}
