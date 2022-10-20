package model1.board;

import java.util.ArrayList;
import java.util.List;

import common.JDBConnect;

public class CommentDAO extends JDBConnect{
	 
	public int insertComment(CommentDTO dto) {
	        int result = 0;
	        
	        try {
	            // INSERT 쿼리문 작성 
	            String query = "INSERT INTO comment ( "
	                         + " num,content,id) "
	                         + " VALUES ( "
	                         + " ?, ?, ?)";  

	            psmt = con.prepareStatement(query);  // 동적 쿼리 
	            psmt.setInt(1, dto.getNum());  
	            psmt.setString(2, dto.getContent());
	            psmt.setString(3, dto.getId());  
	            
	            result = psmt.executeUpdate(); 
	        }
	        catch (Exception e) {
	            System.out.println("댓글 입력 중 예외 발생");
	            e.printStackTrace();
	        }
	        
	        return result;
	    }
	
	// 지정한 게시물을 찾아 내용을 반환합니다.
    public List<CommentDTO> selectComment(String num) { 
              
        List<CommentDTO> list = new ArrayList<CommentDTO>();
        // 쿼리문 준비
        String query = "select * from comment where num=?";

        try {
            psmt = con.prepareStatement(query);
            psmt.setString(1, num);    // 인파라미터를 일련번호로 설정 
            rs = psmt.executeQuery();  // 쿼리 실행 

            // 결과 처리
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
            System.out.println("게시물 상세보기 중 예외 발생");
            e.printStackTrace();
        }
        
        return list; 
    }
    
    public int deleteComment(int deletePK, String id) { 
        int result = 0;

        try {
            // 쿼리문 템플릿
            String query = "DELETE FROM comment WHERE deletePK=? and id=?"; 

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
