package model1.board;

//import java.sql.Date;
import java.sql.Timestamp;

public class ReplyDTO {
	private int deletePK;
	private int selectPK;
	private int num;
	private String content;
	private String id;	
	private Timestamp postdate;
	
	public int getDeletePK() {
		return deletePK;
	}
	public void setDeletePK(int deletePK) {
		this.deletePK = deletePK;
	}
	public int getSelectPK() {
		return selectPK;
	}
	public void setSelectPK(int selectPK) {
		this.selectPK = selectPK;
	}
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public Timestamp getPostdate() {
		return postdate;
	}
	public void setPostdate(Timestamp postdate) {
		this.postdate = postdate;
	}

	
	
}
