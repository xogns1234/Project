package model1.board;

import java.sql.Date;

public class CommentDTO {
	private int deletePK;
	private int num;
	private String content;
	private String id;
	private Date postdate;
		
	public int getDeletePK() {
		return deletePK;
	}
	public void setDeletePK(int deletePK) {
		this.deletePK = deletePK;
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
	public Date getPostdate() {
		return postdate;
	}
	public void setPostdate(Date postdate) {
		this.postdate = postdate;
	}	
	
}
