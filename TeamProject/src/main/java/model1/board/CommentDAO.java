package model1.board;

import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;

public class CommentDAO extends JDBConnect{
	 
	public int insertComment(CommentDTO dto) {
	        int result = 0;
	        
	        try {
	            // INSERT ������ �ۼ� 
	            String query = "INSERT INTO comment ( "
	                         + " num,content,id) "
	                         + " VALUES ( "
	                         + " ?, ?, ?)";  

	            psmt = con.prepareStatement(query);  // ���� ���� 
	            psmt.setInt(1, dto.getNum());  
	            psmt.setString(2, dto.getContent());
	            psmt.setString(3, dto.getId());  
	            
	            result = psmt.executeUpdate(); 
	        }
	        catch (Exception e) {
	            System.out.println("��� �Է� �� ���� �߻�");
	            e.printStackTrace();
	        }
	        
	        return result;
	    }
	
	// ������ �Խù��� ã�� ������ ��ȯ�մϴ�.
    public List<CommentDTO> selectComment(String num) { 
              
        List<CommentDTO> list = new ArrayList<CommentDTO>();
        // ������ �غ�
        String query = "select * from comment where num=?";

        try {
            psmt = con.prepareStatement(query);
            psmt.setString(1, num);    // ���Ķ���͸� �Ϸù�ȣ�� ���� 
            rs = psmt.executeQuery();  // ���� ���� 

            // ��� ó��
            while (rs.next()) {
            	CommentDTO dto = new CommentDTO();
                dto.setNum(rs.getInt("num"));                
                dto.setContent(rs.getString("content"));                
                dto.setId(rs.getString("id"));
                dto.setPostdate(rs.getDate("postdate"));
                dto.setDeletePK(rs.getInt("deletePK"));
                list.add(dto);

            }
        } 
        catch (Exception e) {
            System.out.println("�Խù� �󼼺��� �� ���� �߻�");
            e.printStackTrace();
        }
        
        return list; 
    }
    
    public int deleteComment(int deletePK, String id) { 
        int result = 0;

        try {
            // ������ ���ø�
            String query = "DELETE FROM comment WHERE deletePK=? and id=?"; 

            // ������ �ϼ�
            psmt = con.prepareStatement(query); 
            psmt.setInt(1, deletePK);
            psmt.setString(2, id); 

            // ������ ����
            result = psmt.executeUpdate(); 
        } 
        catch (Exception e) {
            System.out.println("��� ���� �� ���� �߻�");
            e.printStackTrace();
        }
        
        return result; // ��� ��ȯ
    }   
}
