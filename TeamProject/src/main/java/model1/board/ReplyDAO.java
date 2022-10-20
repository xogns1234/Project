package model1.board;

import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;

public class ReplyDAO extends JDBConnect{

	public int insertReply(ReplyDTO dto) {
        int result = 0;
        
        try {
            // INSERT 쿼리문 작성 
            String query = "INSERT INTO reply ( "
                         + " selectPK,num,content,id) "
                         + " VALUES ( "
                         + " ?, ?, ?, ?)";  

            psmt = con.prepareStatement(query);  // 동적 쿼리 
            psmt.setInt(1, dto.getSelectPK());  
            psmt.setInt(2, dto.getNum());  
            psmt.setString(3, dto.getContent());
            psmt.setString(4, dto.getId());  
            
            result = psmt.executeUpdate(); 
        }
        catch (Exception e) {
            System.out.println("댓글 입력 중 예외 발생");
            e.printStackTrace();
        }
        
        return result;
    }

// 지정한 게시물을 찾아 내용을 반환합니다.
public List<ReplyDTO> selectReply(String num) { 
          
    List<ReplyDTO> list = new ArrayList<ReplyDTO>();
    // 쿼리문 준비
    String query = "select * from reply where num=?";

    try {
        psmt = con.prepareStatement(query);
        psmt.setString(1, num);    // 인파라미터를 일련번호로 설정 
        rs = psmt.executeQuery();  // 쿼리 실행 

        // 결과 처리
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
        System.out.println("게시물 상세보기 중 예외 발생");
        e.printStackTrace();
    }
    
    return list; 
}

public int deleteReply(int deletePK, String id) { 
    int result = 0;

    try {
        // 쿼리문 템플릿
        String query = "DELETE FROM reply WHERE deletePK=? and id=?"; 

        // 쿼리문 완성
        psmt = con.prepareStatement(query); 
        psmt.setInt(1, deletePK);
        psmt.setString(2, id); 

        // 쿼리문 실행
        result = psmt.executeUpdate(); 
    } 
    catch (Exception e) {
        System.out.println("댓글 삭제 중 예외 발생");
        e.printStackTrace();
    }
    
    	return result; // 결과 반환
	}   
}
