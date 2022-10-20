package model1.board;

import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;

public class ReplyDAO extends JDBConnect{

	public int insertReply(ReplyDTO dto) {
        int result = 0;
        
        try {
            // INSERT ������ �ۼ� 
            String query = "INSERT INTO reply ( "
                         + " selectPK,num,content,id) "
                         + " VALUES ( "
                         + " ?, ?, ?, ?)";  

            psmt = con.prepareStatement(query);  // ���� ���� 
            psmt.setInt(1, dto.getSelectPK());  
            psmt.setInt(2, dto.getNum());  
            psmt.setString(3, dto.getContent());
            psmt.setString(4, dto.getId());  
            
            result = psmt.executeUpdate(); 
        }
        catch (Exception e) {
            System.out.println("��� �Է� �� ���� �߻�");
            e.printStackTrace();
        }
        
        return result;
    }

// ������ �Խù��� ã�� ������ ��ȯ�մϴ�.
public List<ReplyDTO> selectReply(String num) { 
          
    List<ReplyDTO> list = new ArrayList<ReplyDTO>();
    // ������ �غ�
    String query = "select * from reply where num=?";

    try {
        psmt = con.prepareStatement(query);
        psmt.setString(1, num);    // ���Ķ���͸� �Ϸù�ȣ�� ���� 
        rs = psmt.executeQuery();  // ���� ���� 

        // ��� ó��
        while (rs.next()) {
        	ReplyDTO dto = new ReplyDTO();
        	dto.setSelectPK(rs.getInt("selectPK"));       
        	dto.setNum(rs.getInt("num"));                
            dto.setContent(rs.getString("content"));                
            dto.setId(rs.getString("id"));
            dto.setPostdate(rs.getTimestamp("postdate"));
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

public int deleteReply(int deletePK, String id) { 
    int result = 0;

    try {
        // ������ ���ø�
        String query = "DELETE FROM reply WHERE deletePK=? and id=?"; 

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
