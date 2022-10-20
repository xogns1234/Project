package membership;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;

public class UploadDAO extends JDBConnect {
	
	public void upload(String lat, String lon, String memo, String title, String id) throws SQLException {
		
		PreparedStatement psmt = null;
		try {
			String sql = "insert into uploaddata set Lat=?,lng =?,memo=?,title=?,id = ?,count=?";
			psmt = con.prepareStatement(sql);
			BigDecimal Changelat = new BigDecimal(lat);
			BigDecimal Changelon = new BigDecimal(lon);
			psmt.setBigDecimal(1, Changelat);
			psmt.setBigDecimal(2, Changelon);
			psmt.setString(3, memo);
			psmt.setString(4, title);
			psmt.setString(5, id);
			psmt.setInt(6, 0);
			psmt.executeUpdate();			
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			if(con != null) con.close();
		}		
	}
		
	public List<UploadDTO> getUpload() throws SQLException {		
		List<UploadDTO> list = new ArrayList<UploadDTO>();
		
		
		String query = "select * from uploaddata";
		
		
		try {
			stmt = con.createStatement();			
			rs = stmt.executeQuery(query);	
			
			while(rs.next()) {
				UploadDTO dto = new UploadDTO();
				dto.setLatitude(rs.getString("Lat"));
				dto.setLongitude(rs.getString("lng"));
				dto.setMemo(rs.getString("memo"));
				dto.setDate(rs.getString("regidate"));
				dto.setNum(rs.getInt("num"));
				dto.setTitle(rs.getString("title"));
				dto.setId(rs.getString("id"));
				dto.setCount(rs.getInt("count"));
				list.add(dto);				
			}
		} catch (Exception e) {
			// TODO: handle exception
			System.out.println("회원 조회 실패");
		}finally {
			if(con != null) con.close();
			if(stmt != null) stmt.close(); 
		}
		return list;
	}
	
	public void deleteUploadData(int num) throws SQLException {		
		
		String query = "delete from uploaddata where num="+num+"";
		stmt = con.createStatement();
		stmt.executeUpdate(query);
		if(con != null) con.close();
		if(stmt != null) stmt.close(); 
	}
	
	public void reportUser(int num, String id, int count) throws SQLException {
		
		String query = "update uploaddata set count=? where id=? and num=?";
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, ++count );
			psmt.setString(2, id);
			psmt.setInt(3, num);			
			psmt.executeUpdate();
			
			if(count>=5) {
				deleteUploadData(num);
			}			
		}		
		catch(Exception ex) {
			ex.printStackTrace();
		
		}finally {
			if(con != null) con.close();
			if(stmt != null) psmt.close();
		}
		
		
	}
}
